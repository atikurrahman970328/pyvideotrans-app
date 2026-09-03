import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

import '../../core/constants/app_colors.dart';
import '../../providers/project_provider.dart';
import '../../providers/config_provider.dart';

class MediaImportTab extends StatefulWidget {
  const MediaImportTab({super.key});

  @override
  State<MediaImportTab> createState() => _MediaImportTabState();
}

class _MediaImportTabState extends State<MediaImportTab> {
  VideoPlayerController? _videoController;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _initializePlayer(File file) {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    final project = projectProvider.currentProject;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          const Text(
            "Media Import & Studio Workspace",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
          ),
          const Text(
            "Select or drag your video/audio file for localization processing.",
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 15),

          // Custom Video Dropzone Box
          GestureDetector(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['mp4', 'mkv', 'avi', 'mov', 'mp3', 'wav', 'flac'],
              );
              if (result != null && result.files.single.path != null) {
                File file = File(result.files.single.path!);
                projectProvider.setVideoProject(file);
                _initializePlayer(file);
              }
            },
            child: Container(
              width: double.infinity,
              height: project == null ? 200 : 260,
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: project == null ? AppColors.primary.withOpacity(0.5) : AppColors.secondary,
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(color: AppColors.primaryGlow, blurRadius: 10, spreadRadius: 1),
                ],
              ),
              child: project == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload_rounded, size: 56, color: AppColors.primary),
                        SizedBox(height: 12),
                        Text(
                          "Tap to Browse Source Video or Audio",
                          style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Supports MP4, MKV, MOV, MP3, WAV (Max 2GB)",
                          style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _videoController != null && _videoController!.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: _videoController!.value.aspectRatio,
                                  child: VideoPlayer(_videoController!),
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.movie, size: 48, color: AppColors.secondary),
                                    SizedBox(height: 8),
                                    Text("Video Loaded & Ready", style: TextStyle(color: AppColors.textMain)),
                                  ],
                                ),
                          if (_videoController != null && _videoController!.value.isInitialized)
                            FloatingActionButton.small(
                              backgroundColor: AppColors.primary,
                              onPressed: () {
                                setState(() {
                                  _videoController!.value.isPlaying
                                      ? _videoController!.pause()
                                      : _videoController!.play();
                                });
                              },
                              child: Icon(
                                _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // File Metadata Card
          if (project != null) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardSurfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  const Icon(Icons.insert_drive_file_outlined, color: AppColors.secondary, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain),
                        ),
                        Text(
                          "Size: ${project.fileSizeMB} MB",
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.accentDanger),
                    onPressed: () {
                      projectProvider.clearProject();
                      _videoController?.dispose();
                      _videoController = null;
                      setState(() {});
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Language Direction Config Card
          const Text(
            "Language Configuration",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMain),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              children: [
                _buildDropdownRow(
                  title: "Source Video Language",
                  subtitle: "Original spoken language in the video",
                  value: configProvider.whisperConfig.sourceLanguage,
                  items: const [
                    DropdownMenuItem(value: 'auto', child: Text("Auto Detect (Recommended)")),
                    DropdownMenuItem(value: 'en', child: Text("English")),
                    DropdownMenuItem(value: 'bn', child: Text("Bangla (বাংলা)")),
                    DropdownMenuItem(value: 'hi', child: Text("Hindi (हिंदी)")),
                    DropdownMenuItem(value: 'es', child: Text("Spanish")),
                    DropdownMenuItem(value: 'zh', child: Text("Chinese")),
                  ],
                  onChanged: (val) {
                    if (val != null) configProvider.whisperConfig.sourceLanguage = val;
                  },
                ),
                const Divider(color: AppColors.borderSubtle, height: 25),
                _buildDropdownRow(
                  title: "Target Output Language",
                  subtitle: "Language to translate subtitles and dubbing into",
                  value: configProvider.ttsConfig.targetLanguage,
                  items: const [
                    DropdownMenuItem(value: 'bn', child: Text("Bangla (বাংলা)")),
                    DropdownMenuItem(value: 'en', child: Text("English")),
                    DropdownMenuItem(value: 'hi', child: Text("Hindi (हिंदी)")),
                    DropdownMenuItem(value: 'ar', child: Text("Arabic (العربية)")),
                    DropdownMenuItem(value: 'es', child: Text("Spanish")),
                    DropdownMenuItem(value: 'fr', child: Text("French")),
                  ],
                  onChanged: (val) {
                    if (val != null) configProvider.updateTargetLanguage(val);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow<T>({
    required String title,
    required String subtitle,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
        Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}