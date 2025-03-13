import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorButtons extends ConsumerWidget {
  const ColorButtons({
    super.key,
    required this.color,
    required this.isSelected,
  });
  final bool isSelected;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(
          color: const Color.fromARGB(255, 34, 130, 255),
          width: 3,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
      ),
      height: 26,
      width: 26,
      child: Center(
        child: Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.all(
              color: const Color(0xFF272727),
              width: 1,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
            color: color,
            // boxShadow: const [
            //   BoxShadow(
            //     blurRadius: 4,
            //     color: Colors.black,
            //     offset: Offset(0, 4),
            //   ),
            // ],
          ),
        ),
      ),
    );
  }
}
