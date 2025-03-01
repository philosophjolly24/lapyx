import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/settings.dart';

class MouseWatch extends ConsumerStatefulWidget {
  const MouseWatch({this.onDeleteKeyPressed, required this.child, super.key});
  final Widget child;
  final VoidCallback? onDeleteKeyPressed;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MouseWatchState();
}

class _MouseWatchState extends ConsumerState<MouseWatch> {
  bool isMouseInRegion = false;
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isMouseInRegion = true;
          _focusNode.requestFocus();
        });
      },
      onExit: (_) {
        setState(() {
          isMouseInRegion = false;
          _focusNode.unfocus();
        });
      },
      child: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: (value) {
          if (value.physicalKey == Settings.deleteKey && isMouseInRegion) {
            widget.onDeleteKeyPressed?.call();
          }
        },
        child: widget.child,
      ),
    );
  }
}
