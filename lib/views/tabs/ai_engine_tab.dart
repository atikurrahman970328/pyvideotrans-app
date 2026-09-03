import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/config_provider.dart';

class AIEngineTab extends StatelessWidget {
  const AIEngineTab({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigProvider>(context);
    final whisper = config.whisperConfig;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Speech Recognition & AI Engines",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
          ),
          const Text(
            "Configure Whisper speech-to-text models and translation services.",
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 15),

          // Speech-To-Text (STT) Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.psychology, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text("Speech-To-Text (STT) Provider", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildOptionTile(
                  title: "Faster-Whisper (Recommended)",
                  subtitle: "GPU accelerated, 4x faster execution in Colab",
                  isSelected: whisper.sttEngine == 'faster_whisper',
                  onTap: () => config.updateSTTEngine('faster_whisper'),
                ),
                _buildOptionTile(
                  title: "OpenAI Whisper Local",
                  subtitle: "Standard HuggingFace Whisper pipeline",
                  isSelected: whisper.sttEngine == 'local_whisper',
                  onTap: () => config.updateSTTEngine('local_whisper'),
                ),
                _buildOptionTile(
                  title: "OpenAI Official API",
                  subtitle: "Requires OpenAI API Key (Highest accuracy)",
                  isSelected: whisper.sttEngine == 'openai_api',
                  onTap: () => config.updateSTTEngine('openai_api'),
                ),
                const SizedBox(height: 15),

                // Model Size Selector
                const Text("Whisper Model Architecture Size", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textMain)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['tiny', 'base', 'small', 'medium', 'large-v3'].map((size) {
                    final isSelected = whisper.modelSize == size;
                    return ChoiceChip(
                      label: Text(size.toUpperCase()),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.background,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textMuted,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      onSelected: (val) {
                        if (val) config.updateWhisperModel(size);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Voice Activity Detection (VAD) Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Silero VAD Filter", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
                  subtitle: const Text("Filter out non-speech background noise to prevent AI transcription hallucination.", style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  value: whisper.enableVAD,
                  activeColor: AppColors.primary,
                  onChanged: (val) => config.toggleVAD(val),
                ),
                if (whisper.enableVAD) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("VAD Speech Threshold", style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      Text("${(whisper.vadThreshold * 100).toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary)),
                    ],
                  ),
                  Slider(
                    value: whisper.vadThreshold,
                    min: 0.1,
                    max: 0.9,
                    activeColor: AppColors.secondary,
                    onChanged: (val) {
                      whisper.vadThreshold = val;
                      config.notifyListeners();
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGlow : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderSubtle),
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? AppColors.primary : AppColors.textMuted),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain, fontSize: 13)),
                  Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}