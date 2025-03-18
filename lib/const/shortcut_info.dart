import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShortcutInfo {
  static final Map<ShortcutActivator, Intent> widgetShortcuts = {
    LogicalKeySet(LogicalKeyboardKey.keyX): const WidgetDeleteIntent()
  };

  static final Map<ShortcutActivator, Intent> globalShortcuts = {
    LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyZ):
        const UndoActionIntent(),
    LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyZ):
        const UndoActionIntent(),
    LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyZ,
        LogicalKeyboardKey.shift): const RedoActionIntent(),
    LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyZ,
        LogicalKeyboardKey.shift): const RedoActionIntent(),
  };
}

class WidgetDeleteIntent extends Intent {
  const WidgetDeleteIntent();
}

class UndoActionIntent extends Intent {
  const UndoActionIntent();
}

class RedoActionIntent extends Intent {
  const RedoActionIntent();
}
