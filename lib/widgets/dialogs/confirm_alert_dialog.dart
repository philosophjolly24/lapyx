import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/widgets/custom_button.dart';

class ConfirmAlertDialog extends ConsumerWidget {
  const ConfirmAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = "Confirm",
    this.cancelText = "Cancel",
    this.confirmColor,
    this.isDestructive = false,
  });

  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final bool isDestructive; // For dangerous actions like delete

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color buttonColor = confirmColor ??
        (isDestructive ? Colors.redAccent : Colors.deepPurpleAccent);

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CustomButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(false),
          height: 40,
          label: cancelText,
          labelColor: Colors.white,
          backgroundColor: Colors.transparent,
        ),
        CustomButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          height: 40,
          label: confirmText,
          labelColor: Colors.white,
          backgroundColor: buttonColor,
        ),
      ],
    );
  }

  // Static helper method for easy usage
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = "Confirm",
    String cancelText = "Cancel",
    Color? confirmColor,
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmAlertDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        isDestructive: isDestructive,
      ),
    );

    return result ?? false; // Return false if dialog was dismissed
  }
}
