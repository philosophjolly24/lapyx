import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/team_provider.dart';
import 'package:icarus/widgets/sidebar_widgets/agent_filter.dart';

class TeamPicker extends ConsumerWidget {
  const TeamPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAlly = ref.watch(teamProvider);

    // return Row(
    //   children: [
    //     TextButton(
    //       onPressed: () {
    //         ref.read(teamProvider.notifier).isAlly(true);
    //       },
    //       style: TextButton.styleFrom(
    //         splashFactory: InkRipple.splashFactory,
    //         foregroundColor: isAlly ? Colors.greenAccent : Colors.grey,
    //       ),
    //       child: Text(
    //         "Ally",
    //         style: TextStyle(
    //           color: isAlly ? Colors.greenAccent : Colors.grey,
    //         ),
    //       ),
    //     ),
    //     TextButton(
    //       onPressed: () {
    //         ref.read(teamProvider.notifier).isAlly(false);
    //       },
    //       style: TextButton.styleFrom(
    //         splashFactory: InkRipple.splashFactory,
    //         foregroundColor: !isAlly ? Colors.redAccent : Colors.grey,
    //       ),
    //       child: Text(
    //         "Enemy",
    //         style: TextStyle(
    //           color: !isAlly ? Colors.redAccent : Colors.grey,
    //         ),
    //       ),
    //     )
    //   ],
    // );

    return CustomSlidingSegmentedControl<bool>(
      height: 32,
      initialValue: isAlly,
      decoration: BoxDecoration(
        color: const Color(0xFF313131),
        border: Border.all(color: const Color(0xFF1A161A)),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF1A161A),
            blurRadius: 4.0,
            spreadRadius: -1.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      thumbDecoration: BoxDecoration(
        color: isAlly
            ? const Color.fromARGB(255, 54, 126, 91)
            : const Color(0xFFB73636),
        borderRadius: BorderRadius.circular(42),
      ),
      children: {
        true: Text(
          "Ally",
          style: TextStyle(
            color: isAlly ? Colors.white : const Color(0xFF9E9E9E),
            fontWeight: FontWeight.w500,
          ),
        ),
        false: Text(
          "Enemy",
          style: TextStyle(
            color: !isAlly ? Colors.white : const Color(0xFF9E9E9E),
            fontWeight: FontWeight.w500,
          ),
        ),
      },
      innerPadding: const EdgeInsets.all(4),
      onValueChanged: (value) {
        ref.read(teamProvider.notifier).isAlly(value);
      },
    );
  }
}
