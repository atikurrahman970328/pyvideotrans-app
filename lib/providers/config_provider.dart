import 'package:flutter/material.dart';
import '../models/whisper_config.dart';
import '../models/tts_config.dart';
import '../models/subtitle_style.dart';

class ConfigProvider extends ChangeNotifier {
  // কনফিগারেশন অবজেক্টসমূহ
  final WhisperConfig _whisperConfig = WhisperConfig();
  final TTSConfig _ttsConfig = TTSConfig();
  final SubtitleStyle _subtitleStyle = SubtitleStyle();

  // ব্যাকগ্রাউন্ড মিউজিক সেপারেশন (MDX-Net)
  bool _removeBackgroundMusic = true;
  bool _isolateVocalsFirst = true;

  // Getters
  WhisperConfig get whisperConfig => _whisperConfig;
  TTSConfig get ttsConfig => _ttsConfig;
  SubtitleStyle get subtitleStyle => _subtitleStyle;
  bool get removeBackgroundMusic => _removeBackgroundMusic;
  bool get isolateVocalsFirst => _isolateVocalsFirst;

  // Whisper Config Updaters
  void updateWhisperModel(String model) {
    _whisperConfig.modelSize = model;
    notifyListeners();
  }

  void updateSTTEngine(String engine) {
    _whisperConfig.sttEngine = engine;
    notifyListeners();
  }

  void toggleVAD(bool enabled) {
    _whisperConfig.enableVAD = enabled;
    notifyListeners();
  }

  // TTS Config Updaters
  void updateTTSEngine(String engine) {
    _ttsConfig.engine = engine;
    notifyListeners();
  }

  void updateTargetLanguage(String lang) {
    _ttsConfig.targetLanguage = lang;
    notifyListeners();
  }

  void updateVoiceName(String voice) {
    _ttsConfig.voiceName = voice;
    notifyListeners();
  }

  void updateSpeechSpeed(double speed) {
    _ttsConfig.speedRatio = speed;
    notifyListeners();
  }

  void updatePitch(int pitch) {
    _ttsConfig.pitchShift = pitch;
    notifyListeners();
  }

  // Subtitle Style Updaters
  void updateFontSize(double size) {
    _subtitleStyle.fontSize = size;
    notifyListeners();
  }

  void updateFontColor(Color color) {
    _subtitleStyle.fontColor = color;
    notifyListeners();
  }

  void toggleHardcodeSubtitle(bool enable) {
    _subtitleStyle.enableHardcode = enable;
    notifyListeners();
  }

  // Audio Separation Toggle
  void toggleBackgroundMusicRemoval(bool value) {
    _removeBackgroundMusic = value;
    notifyListeners();
  }
}