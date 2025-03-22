import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/shortcut_info.dart';
import 'package:icarus/providers/action_provider.dart';

class GlobalShortcuts extends ConsumerWidget {
  const GlobalShortcuts({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Focus(
      autofocus: true,
      canRequestFocus: true,
      child: Shortcuts(
        shortcuts: ShortcutInfo.globalShortcuts,
        child: Actions(
          actions: {
            UndoActionIntent: CallbackAction<UndoActionIntent>(
              onInvoke: (intent) {
                ref.read(actionProvider.notifier).undoAction();
                return null;
              },
            ),
            RedoActionIntent: CallbackAction<RedoActionIntent>(
              onInvoke: (intent) {
                log("I triggered");

                ref.read(actionProvider.notifier).redoAction();
                return null;
              },
            ),
          },
          child: child,
        ),
      ),
    );
  }
}
