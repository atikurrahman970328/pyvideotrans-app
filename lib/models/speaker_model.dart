import 'dart:io';

class SpeakerProfile {
  final String id; // e.g., SPEAKER_00, SPEAKER_01
  String displayName;
  String gender; // Male, Female, Child
  String ageGroup; // Child, Young, Adult, Senior
  String ttsVoice; // EdgeTTS voice id
  File? voiceCloneSample; // Audio sample for Voice Cloning (Coqui/XTTS)

  SpeakerProfile({
    required this.id,
    required this.displayName,
    this.gender = 'Male',
    this.ageGroup = 'Adult',
    this.ttsVoice = 'bn-BD-PradeepNeural',
    this.voiceCloneSample,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'gender': gender,
        'ageGroup': ageGroup,
        'ttsVoice': ttsVoice,
        'hasCloneSample': voiceCloneSample != null,
      };
}