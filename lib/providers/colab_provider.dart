import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/processing_log.dart';
import '../models/video_project.dart';
import '../services/colab_api_service.dart';
import 'config_provider.dart';

class ColabProvider extends ChangeNotifier {
  String _colabBaseUrl = '';
  bool _isConnected = false;
  bool _isConnecting = false;

  // টাস্ক এক্সিকিউশন স্ট্যাটাস
  bool _isProcessing = false;
  double _progressPercentage = 0.0; // 0.0 to 1.0
  String _currentStepMessage = 'Idle';
  String? _outputVideoUrl;

  // কনসোল লগ লিস্ট
  final List<ProcessingLog> _logs = [];

  // Getters
  String get colabBaseUrl => _colabBaseUrl;
  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  bool get isProcessing => _isProcessing;
  double get progressPercentage => _progressPercentage;
  String get currentStepMessage => _currentStepMessage;
  String? get outputVideoUrl => _outputVideoUrl;
  List<ProcessingLog> get logs => List.unmodifiable(_logs);

  // Colab Ngrok URL সেটআপ ও হেলথ চেক
  Future<bool> connectToColab(String url) async {
    String formattedUrl = url.trim();
    if (formattedUrl.endsWith('/')) {
      formattedUrl = formattedUrl.substring(0, formattedUrl.length - 1);
    }

    _isConnecting = true;
    notifyListeners();

    _addLog("Checking connection to: $formattedUrl", LogType.info);

    bool success = await ColabApiService.checkConnection(formattedUrl);
    _isConnecting = false;

    if (success) {
      _colabBaseUrl = formattedUrl;
      _isConnected = true;
      _addLog("Connected to Colab GPU Backend successfully!", LogType.success);
    } else {
      _isConnected = false;
      _addLog("Failed to connect to Colab. Check Ngrok URL.", LogType.error);
    }

    notifyListeners();
    return _isConnected;
  }

  // ভিডিও প্রসেসিং টাস্ক শুরু করা
  Future<void> executeVideoTranslation({
    required VideoProject project,
    required ConfigProvider config,
  }) async {
    if (!_isConnected || _colabBaseUrl.isEmpty) {
      _addLog("Error: Not connected to Colab backend!", LogType.error);
      return;
    }

    _isProcessing = true;
    _progressPercentage = 0.05;
    _currentStepMessage = "Uploading video to Colab GPU...";
    _addLog("Starting task for video: ${project.fileName}", LogType.info);
    notifyListeners();

    try {
      final response = await ColabApiService.startVideoTranslation(
        baseUrl: _colabBaseUrl,
        videoFile: project.file,
        whisperConfig: config.whisperConfig,
        ttsConfig: config.ttsConfig,
        subtitleStyle: config.subtitleStyle,
        removeBackgroundMusic: config.removeBackgroundMusic,
      );

      if (response.statusCode == 200) {
        _addLog("Video uploaded. Processing initiated on Colab...", LogType.info);
        
        // Colab এর স্ট্রিমিং রেসপন্স পড়া
        response.stream.transform(utf8.decoder).listen(
          (data) {
            _parseServerProgressStream(data);
          },
          onDone: () {
            _isProcessing = false;
            _progressPercentage = 1.0;
            _currentStepMessage = "Translation Completed!";
            _addLog("Full Video Processing Finished!", LogType.success);
            notifyListeners();
          },
          onError: (error) {
            _isProcessing = false;
            _addLog("Error during streaming: $error", LogType.error);
            notifyListeners();
          },
        );
      } else {
        _isProcessing = false;
        _addLog("Server returned error status: ${response.statusCode}", LogType.error);
        notifyListeners();
      }
    } catch (e) {
      _isProcessing = false;
      _addLog("Task Exception: $e", LogType.error);
      notifyListeners();
    }
  }

  // সার্ভার স্ট্রিম পার্স করা
  void _parseServerProgressStream(String chunk) {
    try {
      final lines = chunk.split('\n');
      for (var line in lines) {
        if (line.trim().isEmpty) continue;
        final data = jsonDecode(line);

        if (data.containsKey('progress')) {
          _progressPercentage = (data['progress'] as num).toDouble();
        }
        if (data.containsKey('stage')) {
          _currentStepMessage = data['stage'];
          _addLog(_currentStepMessage, LogType.info);
        }
        if (data.containsKey('output_url')) {
          _outputVideoUrl = data['output_url'];
        }
        notifyListeners();
      }
    } catch (_) {
      // র ইমার্জেন্সি লগ
      _addLog(chunk, LogType.debug);
    }
  }

  void _addLog(String msg, LogType type) {
    _logs.insert(0, ProcessingLog(timestamp: DateTime.now(), message: msg, type: type));
    notifyListeners();
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }
}