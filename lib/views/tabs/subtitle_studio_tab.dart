import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/config_provider.dart';

class SubtitleStudioTab extends StatelessWidget {
  const SubtitleStudioTab({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigProvider>(context);
    final subStyle = config.subtitleStyle;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Subtitle & Typography Studio",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
          ),
          const Text(
            "Design hardcoded video subtitles, font sizes, margins, and overlay colors.",
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 15),

          // Hardcode Toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Hardcode Subtitle onto Video", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
              subtitle: const Text("Burn subtitles permanently into the rendered MP4 file.", style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
              value: subStyle.enableHardcode,
              activeColor: AppColors.primary,
              onChanged: (val) => config.toggleHardcodeSubtitle(val),
            ),
          ),
          const SizedBox(height: 20),

          // Subtitle Preview Card
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                const Center(
                  child: Icon(Icons.movie_creation_outlined, color: Colors.white24, size: 50),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: subStyle.backgroundColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "এখানে সাবটাইটেল প্রিভিউ দেখা যাবে",
                      style: TextStyle(
                        fontSize: subStyle.fontSize * 0.6,
                        color: subStyle.fontColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Customization Controls
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
                // Font Size Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Font Size (px)", style: TextStyle(fontSize: 13, color: AppColors.textMain)),
                    Text("${subStyle.fontSize.toInt()} px", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary)),
                  ],
                ),
                Slider(
                  value: subStyle.fontSize,
                  min: 12,
                  max: 48,
                  activeColor: AppColors.secondary,
                  onChanged: (val) => config.updateFontSize(val),
                ),
                const SizedBox(height: 15),

                // Font Color Pickers
                const Text("Subtitle Text Color", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildColorChip(config, Colors.white, "White"),
                    _buildColorChip(config, Colors.yellow, "Yellow"),
                    _buildColorChip(config, Colors.cyan, "Cyan"),
                    _buildColorChip(config, Colors.greenAccent, "Green"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorChip(ConfigProvider config, Color color, String name) {
    final isSelected = config.subtitleStyle.fontColor == color;
    return GestureDetector(
      onTap: () => config.updateFontColor(color),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.black26,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Text(
          name,
          style: const TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}