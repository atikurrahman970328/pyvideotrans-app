import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/colab_provider.dart';
import '../../providers/config_provider.dart';
import '../../providers/project_provider.dart';
import '../tabs/media_import_tab.dart';
import '../tabs/ai_engine_tab.dart';
import '../tabs/voice_dubbing_tab.dart';
import '../tabs/subtitle_studio_tab.dart';
import '../tabs/audio_processing_tab.dart';
import '../modals/colab_connect_modal.dart';
import 'processing_console_screen.dart';

class MainStudioScreen extends StatefulWidget {
  const MainStudioScreen({super.key});

  @override
  State<MainStudioScreen> createState() => _MainStudioScreenState();
}

class _MainStudioScreenState extends State<MainStudioScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colab = Provider.of<ColabProvider>(context);
    final project = Provider.of<ProjectProvider>(context);
    final config = Provider.of<ConfigProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardSurface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.translate_rounded, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              "PyVideoTrans Studio",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMain),
            ),
          ],
        ),
        actions: [
          // Connection Status Indicator
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const ColabConnectModal(),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colab.isConnected
                    ? AppColors.accentSuccess.withOpacity(0.15)
                    : AppColors.accentDanger.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colab.isConnected ? AppColors.accentSuccess : AppColors.accentDanger,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: colab.isConnected ? AppColors.accentSuccess : AppColors.accentDanger,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    colab.isConnected ? "GPU Connected" : "Connect Colab",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colab.isConnected ? AppColors.accentSuccess : AppColors.accentDanger,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          tabs: const [
            Tab(icon: Icon(Icons.video_file_outlined), text: "Media"),
            Tab(icon: Icon(Icons.memory_outlined), text: "AI Engine"),
            Tab(icon: Icon(Icons.record_voice_over_outlined), text: "Voice Dub"),
            Tab(icon: Icon(Icons.subtitles_outlined), text: "Subtitles"),
            Tab(icon: Icon(Icons.graphic_eq_outlined), text: "Audio Stems"),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                MediaImportTab(),
                AIEngineTab(),
                VoiceDubbingTab(),
                SubtitleStudioTab(),
                AudioProcessingTab(),
              ],
            ),
          ),

          // Bottom Execution Control Panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              border: Border(top: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        project.hasProject ? project.currentProject!.fileName : "No Video Selected",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain),
                      ),
                      Text(
                        "Target: ${config.ttsConfig.targetLanguage.toUpperCase()} | Voice: ${config.ttsConfig.voiceName.split('-').last}",
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                  label: const Text("Start Task", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: (!project.hasProject || colab.isProcessing)
                      ? null
                      : () {
                          if (!colab.isConnected) {
                            showDialog(
                              context: context,
                              builder: (context) => const ColabConnectModal(),
                            );
                            return;
                          }

                          colab.executeVideoTranslation(
                            project: project.currentProject!,
                            config: config,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProcessingConsoleScreen()),
                          );
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}