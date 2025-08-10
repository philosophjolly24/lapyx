import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/action_provider.dart';
import 'package:icarus/providers/text_provider.dart';
import 'package:icarus/widgets/mouse_watch.dart';

class TextWidget extends ConsumerStatefulWidget {
  const TextWidget({
    super.key,
    required this.text,
    this.isDragged,
    required this.id,
  });
  final String text;
  final bool? isDragged;
  final String id;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends ConsumerState<TextWidget> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) return;

    ref.read(textProvider.notifier).editText(_controller.text, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.text;
    return MouseWatch(
      cursor: SystemMouseCursors.click,
      onDeleteKeyPressed: () {
        final action = UserAction(
            type: ActionType.deletion, id: widget.id, group: ActionGroup.text);

        ref.read(actionProvider.notifier).addAction(action);
        ref.read(textProvider.notifier).removeText(widget.id);
      },
      child: SizedBox(
        width: 200,
        child: IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                child: Container(
                  width: 10,
                  color: const Color(0xFFC5C5C5),
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  margin: const EdgeInsets.all(0),
                  color: Colors.black,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Write here...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      onTapOutside: (event) {
                        _focusNode.unfocus();
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
