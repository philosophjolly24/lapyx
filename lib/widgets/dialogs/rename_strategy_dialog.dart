import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/strategy_provider.dart';
import 'package:icarus/widgets/custom_button.dart';
import 'package:icarus/widgets/custom_text_field.dart';

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
      content: CustomTextField(
        hintText: widget.currentName,
        controller: _textController,
        textAlign: TextAlign.start,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text("Cancel"),
        ),
        CustomButton(
          onPressed: () async {
            final strategyName = _textController.text;
            if (strategyName.isNotEmpty) {
              await ref
                  .read(strategyProvider.notifier)
                  .renameStrategy(widget.strategyId, strategyName);
              if (!context.mounted) return;
              Navigator.of(context).pop(true); // Close the dialog with success
            } else {
              // Optionally, show an error message if the name is empty
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Strategy name cannot be empty."),
                ),
              );
            }
          },
          height: 35,
          icon: const Icon(Icons.text_fields),
          label: "Rename",
          labelColor: Colors.white,
          backgroundColor: Colors.deepPurple,
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
