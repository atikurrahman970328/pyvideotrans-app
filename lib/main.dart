import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_colors.dart';
import 'providers/colab_provider.dart';
import 'providers/config_provider.dart';
import 'providers/project_provider.dart';
import 'views/screens/main_studio_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PyVideoTransApp());
}

class PyVideoTransApp extends StatelessWidget {
  const PyVideoTransApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ColabProvider()),
        ChangeNotifierProvider(create: (_) => ConfigProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: MaterialApp(
        title: 'PyVideoTrans Mobile Studio',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.background,
          primaryColor: AppColors.primary,
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const MainStudioScreen(),
      ),
    );
  }
}