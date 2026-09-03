import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../core/constants/app_colors.dart';
import '../../providers/config_provider.dart';
import '../../models/speaker_model.dart';

class VoiceDubbingTab extends StatefulWidget {
  const VoiceDubbingTab({super.key});

  @override
  State<VoiceDubbingTab> createState() => _VoiceDubbingTabState();
}

class _VoiceDubbingTabState extends State<VoiceDubbingTab> {
  // Demo detected speakers list
  final List<SpeakerProfile> _speakers = [
    SpeakerProfile(id: "SPEAKER_01", displayName: "Speaker 1 (Main Host)", gender: "Male", ageGroup: "Adult", ttsVoice: "bn-BD-PradeepNeural"),
    SpeakerProfile(id: "SPEAKER_02", displayName: "Speaker 2 (Guest Child)", gender: "Child", ageGroup: "Child", ttsVoice: "bn-BD-NabanitaNeural"),
  ];

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Multi-Speaker & Voice Clone Mapping Studio",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
          ),
          const Text(
            "ভিডিওতে থাকা প্রতিটি চরিত্র বা স্পিকারের জন্য আলাদাভাবে পুরুষ, নারী, শিশুর কণ্ঠ বা ভয়েস ক্লোনিং স্যাম্পল সেট করুন।",
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 15),

          // Speaker List Cards
          ..._speakers.map((speaker) => _buildSpeakerControlCard(speaker, config)),

          const SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cardSurface,
              side: const BorderSide(color: AppColors.primary),
            ),
            icon: const Icon(Icons.add, color: AppColors.primary),
            label: const Text("Add Custom Speaker Assignment", style: TextStyle(color: AppColors.primary)),
            onPressed: () {
              setState(() {
                _speakers.add(SpeakerProfile(
                  id: "SPEAKER_0${_speakers.length + 1}",
                  displayName: "Speaker ${_speakers.length + 1}",
                ));
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakerControlCard(SpeakerProfile speaker, ConfigProvider config) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.record_voice_over, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    speaker.displayName,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain, fontSize: 15),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(speaker.id, style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const Divider(color: AppColors.borderSubtle, height: 20),

          // Gender & Age Selection Dropdowns
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Gender (লিঙ্গ)", style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    const SizedBox(height: 4),
                    _buildDropdown<String>(
                      value: speaker.gender,
                      items: ['Male', 'Female', 'Child/Neutral'],
                      onChanged: (val) {
                        if (val != null) setState(() => speaker.gender = val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Age Group (বয়সের ক্যাটাগরি)", style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    const SizedBox(height: 4),
                    _buildDropdown<String>(
                      value: speaker.ageGroup,
                      items: ['Child (শিশু)', 'Young (তরুণ)', 'Adult (প্রাপ্তবয়স্ক)', 'Senior (বয়স্ক)'],
                      onChanged: (val) {
                        if (val != null) setState(() => speaker.ageGroup = val);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // TTS Voice vs Custom Voice Cloning Option
          const Text("Voice Output Mode", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMain)),
          const SizedBox(height: 6),

          // Standard Neural Voice Selector
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Preset AI Voice Profile", style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              const SizedBox(height: 4),
              _buildDropdown<String>(
                value: speaker.ttsVoice,
                items: [
                  'bn-BD-PradeepNeural',
                  'bn-BD-NabanitaNeural',
                  'en-US-AnaNeural',
                  'en-US-GuyNeural',
                ],
                onChanged: (val) {
                  if (val != null) setState(() => speaker.ttsVoice = val);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Custom Voice Clone Sample Uploader
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              children: [
                const Icon(Icons.mic_none_rounded, color: AppColors.secondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Voice Clone Reference Audio",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textMain),
                      ),
                      Text(
                        speaker.voiceCloneSample == null
                            ? "কারো অডিও স্যাম্পল (১০-৩০ সেকেণ্ড) আপলোড করে তার কণ্ঠ ক্লোন করুন"
                            : "Sample: ${speaker.voiceCloneSample!.path.split('/').last}",
                        style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
                    if (result != null && result.files.single.path != null) {
                      setState(() {
                        speaker.voiceCloneSample = File(result.files.single.path!);
                      });
                    }
                  },
                  child: Text(
                    speaker.voiceCloneSample == null ? "Clone Audio" : "Change",
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          dropdownColor: AppColors.cardSurface,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString(), style: const TextStyle(fontSize: 12, color: AppColors.textMain)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}