import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomButton extends ConsumerWidget {
  const CustomButton({
    required this.onPressed,
    required this.height,
    required this.icon,
    required this.label,
    required this.labelColor,
    required this.backgroundColor,
    this.width,
    this.padding,
    this.fontWeight,
    super.key,
  });

  final Function()? onPressed;
  final double height;
  final double? width;
  final Widget icon;
  final String label;
  final Color labelColor;
  final Color backgroundColor;
  final FontWeight? fontWeight;
  final WidgetStateProperty<EdgeInsetsGeometry>? padding;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height,
      width: width,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(
          label,
          // textAlign: TextAlign.center,
          style: TextStyle(color: labelColor, fontWeight: fontWeight),
        ),
        style: ButtonStyle(
          alignment: Alignment.center,
          padding: padding,
          backgroundColor: WidgetStateProperty.all(backgroundColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.white.withAlpha(51);
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
