import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/team_provider.dart';

class TeamPicker extends ConsumerWidget {
  const TeamPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAlly = ref.watch(teamProvider);

    return Row(
      children: [
        TextButton(
          onPressed: () {
            ref.read(teamProvider.notifier).isAlly(true);
          },
          style: TextButton.styleFrom(
            splashFactory: InkRipple.splashFactory,
            foregroundColor: isAlly ? Colors.greenAccent : Colors.grey,
          ),
          child: Text(
            "Ally",
            style: TextStyle(
              color: isAlly ? Colors.greenAccent : Colors.grey,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            ref.read(teamProvider.notifier).isAlly(false);
          },
          style: TextButton.styleFrom(
            splashFactory: InkRipple.splashFactory,
            foregroundColor: !isAlly ? Colors.redAccent : Colors.grey,
          ),
          child: Text(
            "Enemy",
            style: TextStyle(
              color: !isAlly ? Colors.redAccent : Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
