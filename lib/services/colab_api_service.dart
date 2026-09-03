import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/whisper_config.dart';
import '../models/tts_config.dart';
import '../models/subtitle_style.dart';

class ColabApiService {
  // সার্ভার হেলথ চেক / কানেকশন ভ্যালিডেশন
  static Future<bool> checkConnection(String baseUrl) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ভিডিও ও সব সেটিংস একসাথে Colab API-তে পাঠানো
  static Future<http.StreamedResponse> startVideoTranslation({
    required String baseUrl,
    required File videoFile,
    required WhisperConfig whisperConfig,
    required TTSConfig ttsConfig,
    required SubtitleStyle subtitleStyle,
    required bool removeBackgroundMusic,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/process-video');
    final request = http.MultipartRequest('POST', uri);

    // ১. ভিডিও ফাইল অ্যাটাচ করা
    request.files.add(
      await http.MultipartFile.fromPath(
        'video_file',
        videoFile.path,
      ),
    );

    // ২. সব কাস্টম সেটিংস JSON আকারে পাঠানো
    request.fields['whisper_config'] = jsonEncode(whisperConfig.toJson());
    request.fields['tts_config'] = jsonEncode(ttsConfig.toJson());
    request.fields['subtitle_config'] = jsonEncode(subtitleStyle.toJson());
    request.fields['remove_bg_music'] = removeBackgroundMusic.toString();

    // Multipart Request এক্সিকিউট করা
    return await request.send();
  }

  // প্রসেস হওয়া আউটপুট ভিডিও ডাউনলোড করা
  static String getDownloadUrl(String baseUrl, String taskId) {
    return '$baseUrl/api/v1/download/$taskId';
  }
}