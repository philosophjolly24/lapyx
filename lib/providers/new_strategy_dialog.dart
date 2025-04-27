import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/strategy_provider.dart';

class CreateStrategyDialog extends ConsumerStatefulWidget {
  const CreateStrategyDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NameStrategyDialogState();
}

class _NameStrategyDialogState extends ConsumerState<CreateStrategyDialog> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Name Strategy"),
      content: TextField(
        controller: _textController,
        decoration: InputDecoration(
          hintText: "Enter strategy name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(), // Default border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor, // Focused border color
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0), // Padding inside the text field
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          // Use ElevatedButton for emphasis
          onPressed: () async {
            final strategyName = _textController.text;
            if (strategyName.isNotEmpty) {
              await ref
                  .read(strategyProvider.notifier)
                  .createNewStrategy(strategyName);
              if (!context.mounted) return;
              Navigator.of(context).pop(); // Close the dialog
            } else {
              // Optionally, show an error message if the name is empty
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Strategy name cannot be empty."),
                ),
              );
            }
          },
          child: const Text("Create"),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12.0), // Rounded corners for the dialog
      ),
    );
  }
}
// How to use it:
// showDialog(
//   context: context,
//   builder: (context) => const NameStrategyDialog(),
// );
