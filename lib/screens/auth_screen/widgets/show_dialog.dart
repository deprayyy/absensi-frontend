import 'package:flutter/material.dart';

enum DialogType { success, error, warning, info }

class ModernDialog {
  static void show(
      BuildContext context, {
        required DialogType type,
        String? title,
        String? message,
        Widget? customContent,
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
          backgroundColor: _getBackgroundColor(type),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (customContent != null)
                  customContent
                else ...[
                  Icon(iconData, color: iconColor, size: 70),
                  if (message != null && message.isNotEmpty) ...[
                    const SizedBox(height: 12),
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

  static Color _getBackgroundColor(DialogType type) {
    switch (type) {
      case DialogType.success:
        return Colors.green[50]!;
      case DialogType.error:
        return Colors.red[50]!;
      case DialogType.warning:
        return Colors.orange[50]!;
      case DialogType.info:
        return Colors.blue[50]!;
      default:
        return Colors.grey[50]!;
    }
  }
}