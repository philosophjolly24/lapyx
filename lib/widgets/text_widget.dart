import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextWidget extends ConsumerWidget {
  const TextWidget(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.black,
      width: 200,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 50,
            color: Colors.grey,
          ),
          const Expanded(
              child: TextField(
            decoration: InputDecoration(hintText: "Text here"),
          ))
        ],
      ),
    );
  }
}
