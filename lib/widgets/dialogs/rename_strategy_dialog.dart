import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/strategy_provider.dart';

class RenameStrategyDialog extends ConsumerStatefulWidget {
  final String strategyId;
  final String currentName;

  const RenameStrategyDialog({
    super.key,
    required this.strategyId,
    required this.currentName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RenameStrategyDialogState();
}

class _RenameStrategyDialogState extends ConsumerState<RenameStrategyDialog> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = widget.currentName;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rename Strategy"),
      content: TextField(
        controller: _textController,
        decoration: InputDecoration(
          hintText: widget.currentName,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(), // Default border color
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
        SizedBox(
          height: 35,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            onPressed: () async {
              final strategyName = _textController.text;
              if (strategyName.isNotEmpty) {
                await ref
                    .read(strategyProvider.notifier)
                    .renameStrategy(widget.strategyId, strategyName);
                if (!context.mounted) return;
                Navigator.of(context)
                    .pop(true); // Close the dialog with success
              } else {
                // Optionally, show an error message if the name is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Strategy name cannot be empty."),
                  ),
                );
              }
            },
            child: const Text("Rename"),
          ),
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
//   builder: (context) => RenameStrategyDialog(
//     strategyId: "your_strategy_id",
//     currentName: "Current Strategy Name",
//   ),
// );
