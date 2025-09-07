import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/strategy_provider.dart';
import 'package:icarus/widgets/custom_button.dart';
import 'package:icarus/widgets/custom_text_field.dart';

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
      content: CustomTextField(
        hintText: "Enter strategy name",
        controller: _textController,
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
              final strategyID = await ref
                  .read(strategyProvider.notifier)
                  .createNewStrategy(strategyName);
              if (!context.mounted) return;
              Navigator.of(context).pop(strategyID); // Close the dialog
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
          icon: const Icon(Icons.draw),
          label: "Create",
          labelColor: Colors.white,
          backgroundColor: Colors.deepPurple,
        )
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
