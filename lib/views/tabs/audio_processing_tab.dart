import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/config_provider.dart';

class AudioProcessingTab extends StatelessWidget {
  const AudioProcessingTab({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Audio Track Separation & Demixing",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
          ),
          const Text(
            "Separate original video audio into Vocals and Background Music (BGM) stems.",
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Isolate & Remove Background Music", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
                  subtitle: const Text("Uses MDX-Net AI model to strip music before applying voice dubbing.", style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  value: config.removeBackgroundMusic,
                  activeColor: AppColors.primary,
                  onChanged: (val) => config.toggleBackgroundMusicRemoval(val),
                ),
                const Divider(color: AppColors.borderSubtle, height: 25),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.graphic_eq, color: AppColors.secondary),
                  title: const Text("Demixing Algorithm", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain, fontSize: 13)),
                  subtitle: const Text("UVR5 MDX-Net Extra High Quality", style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text("GPU Ready", style: TextStyle(color: AppColors.secondary, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}