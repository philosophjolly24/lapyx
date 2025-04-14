import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageWidget extends ConsumerStatefulWidget {
  const ImageWidget({super.key, required this.image, required this.text});
  final Image image;
  final String text;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends ConsumerState<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 400,
        maxWidth: 400,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                color: Color(0xFFC5C5C5),
              ),
              width: 10,
            ),
            const SizedBox(width: 2),
            Flexible(
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                margin: const EdgeInsets.all(0),
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    // height: 290,

                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 20, 20, 20),
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                    child: widget.image,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
