import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../cores/themes/text_styles.dart';
import 'custom_button.dart';

enum DialogType { success, failed }

class StatusDialog extends StatelessWidget {
  final DialogType type;
  final String title;
  final String message;
  final Function()? onOkPressed;
  final String? okButtonText;

  const StatusDialog({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.onOkPressed,
    this.okButtonText,
  });

  @override
  Widget build(BuildContext context) {
    final isSuccess = type == DialogType.success;
    final animationAsset = isSuccess
        ? 'assets/animations/success.json'
        : 'assets/animations/failed.json';

    final primaryColor = isSuccess ? Colors.green : Colors.red;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lottie Animation
            SizedBox(
              width: 120,
              height: 120,
              child: Lottie.asset(
                animationAsset,
                repeat: false,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              title,
              style: AppTextStyles.heading3.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Message
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // OK Button
            CustomButton.filled(
              onPressed: () {
                if (onOkPressed != null) {
                  onOkPressed!();
                }
              },
              label: okButtonText ?? 'OK',
              color: primaryColor,
              textColor: Colors.white,
              height: 50,
              borderRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}

// Static methods for easier usage
class StatusDialogs {
  static bool _isDialogShowing = false;

  static void showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    Function? onOkPressed,
    String? okButtonText,
  }) {
    if (_isDialogShowing) return;

    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatusDialog(
        type: DialogType.success,
        title: title,
        message: message,
        onOkPressed: () {
          _isDialogShowing = false;
          Navigator.of(context).pop(); // Close dialog first
          if (onOkPressed != null) {
            onOkPressed(); // Then execute callback
          }
        },
        okButtonText: okButtonText,
      ),
    ).then((_) => _isDialogShowing = false);
  }

  static void showFailed(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onOkPressed,
    String? okButtonText,
  }) {
    if (_isDialogShowing) return; // Prevent multiple dialogs

    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatusDialog(
        type: DialogType.failed,
        title: title,
        message: message,
        onOkPressed: () {
          _isDialogShowing = false;
          Navigator.of(context).pop(); // Close dialog first
          if (onOkPressed != null) {
            onOkPressed(); // Then execute callback
          }
        },
        okButtonText: okButtonText,
      ),
    ).then((_) => _isDialogShowing = false);
  }
}
