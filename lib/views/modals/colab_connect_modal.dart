import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/colab_provider.dart';

class ColabConnectModal extends StatefulWidget {
  const ColabConnectModal({super.key});

  @override
  State<ColabConnectModal> createState() => _ColabConnectModalState();
}

class _ColabConnectModalState extends State<ColabConnectModal> {
  late TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    final colab = Provider.of<ColabProvider>(context, listen: false);
    _urlController = TextEditingController(text: colab.colabBaseUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colab = Provider.of<ColabProvider>(context);

    return Dialog(
      backgroundColor: AppColors.cardSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.cloud_sync_rounded, color: AppColors.primary, size: 28),
                SizedBox(width: 10),
                Text(
                  "Connect Google Colab GPU",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Colab নোটবুক রান করে প্রাপ্ত Ngrok পাবলিক URL-টি নিচে পেস্ট করুন।",
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 16),

            // Ngrok URL Input
            TextField(
              controller: _urlController,
              style: const TextStyle(color: AppColors.textMain),
              decoration: InputDecoration(
                hintText: "https://xxxx.ngrok-free.app",
                hintStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.background,
                prefixIcon: const Icon(Icons.link, color: AppColors.secondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.borderSubtle),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.borderSubtle),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel", style: TextStyle(color: AppColors.textMuted)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: colab.isConnecting
                      ? null
                      : () async {
                          bool success = await colab.connectToColab(_urlController.text);
                          if (context.mounted) {
                            if (success) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Connected to GPU Server!"),
                                  backgroundColor: AppColors.accentSuccess,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Connection Failed! Check URL."),
                                  backgroundColor: AppColors.accentDanger,
                                ),
                              );
                            }
                          }
                        },
                  child: colab.isConnecting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text("Connect Server", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}