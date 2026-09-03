import 'dart:io';
import 'package:flutter/material.dart';
import '../models/video_project.dart';

class ProjectProvider extends ChangeNotifier {
  VideoProject? _currentProject;

  VideoProject? get currentProject => _currentProject;
  bool get hasProject => _currentProject != null;

  void setVideoProject(File file) {
    final fileName = file.path.split('/').last;
    final fileSizeMB = file.lengthSync() / (1024 * 1024);

    _currentProject = VideoProject(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      file: file,
      fileName: fileName,
      fileSizeMB: double.parse(fileSizeMB.toStringAsFixed(2)),
    );

    notifyListeners();
  }

  void clearProject() {
    _currentProject = null;
    notifyListeners();
  }
}