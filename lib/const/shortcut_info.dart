import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShortcutInfo {
  static final Map<ShortcutActivator, Intent> widgetShortcuts = {
    LogicalKeySet(LogicalKeyboardKey.keyE): const WidgetDeleteIntent()
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
    LogicalKeySet(LogicalKeyboardKey.keyQ): const ToggleDrawingIntent(),
    LogicalKeySet(LogicalKeyboardKey.keyW): const ToggleErasingIntent(),
  };
}

class WidgetDeleteIntent extends Intent {
  const WidgetDeleteIntent();
}

class ToggleDrawingIntent extends Intent {
  const ToggleDrawingIntent();
}

class ToggleErasingIntent extends Intent {
  const ToggleErasingIntent();
}

class UndoActionIntent extends Intent {
  const UndoActionIntent();
}

class RedoActionIntent extends Intent {
  const RedoActionIntent();
}
