import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum DialogType { success, error, warning, info }

class ModernDialog {
  static void show(
      BuildContext context, {
        required DialogType type,
        String? title,
        String? message,
        Widget? customContent,
        String? lottieAsset,
        bool autoClose = false,
        Duration autoCloseDuration = const Duration(seconds: 1),
        VoidCallback? onClose,
      }) {
    final Color iconColor;
    final IconData iconData;

    switch (type) {
      case DialogType.success:
        iconColor = Colors.green;
        iconData = Icons.check_circle_rounded;
        break;
      case DialogType.error:
        iconColor = Colors.red;
        iconData = Icons.cancel_rounded;
        break;
      case DialogType.warning:
        iconColor = Colors.orange;
        iconData = Icons.warning_amber_rounded;
        break;
      case DialogType.info:
        iconColor = Colors.blue;
        iconData = Icons.info_rounded;
        break;
    }

    showDialog(
      context: context,
      barrierDismissible: !autoClose,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (customContent != null)
                  customContent
                else ...[
                  if (lottieAsset != null)
                    Lottie.asset(
                      lottieAsset,
                      width: 120,
                      height: 120,
                      repeat: false,
                    )
                  else
                    Icon(iconData, color: iconColor, size: 70),
                  if (title != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: iconColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (message != null && message.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );

    if (autoClose) {
      Future.delayed(autoCloseDuration, () {
        Navigator.of(context, rootNavigator: true).pop();
        onClose?.call();
      });
    }
  }
}
