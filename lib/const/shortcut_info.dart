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
    LogicalKeySet(LogicalKeyboardKey.keyT): const AddedTextIntent(),
  };

  // New map to disable global shortcuts when typing
  static final Map<ShortcutActivator, Intent> textEditingOverrides = {
    // Override Ctrl+Z/Cmd+Z (let the TextField handle these)
    LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyZ):
        const DoNothingAndStopPropagationIntent(),
    LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyZ):
        const DoNothingAndStopPropagationIntent(),

    LogicalKeySet(LogicalKeyboardKey.keyT):
        const DoNothingAndStopPropagationIntent(),
    // Override Ctrl+Shift+Z/Cmd+Shift+Z
    LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyZ,
        LogicalKeyboardKey.shift): const DoNothingAndStopPropagationIntent(),
    LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyZ,
        LogicalKeyboardKey.shift): const DoNothingAndStopPropagationIntent(),

    // Override Q and W shortcuts
    LogicalKeySet(LogicalKeyboardKey.keyQ):
        const DoNothingAndStopPropagationIntent(),
    LogicalKeySet(LogicalKeyboardKey.keyW):
        const DoNothingAndStopPropagationIntent(),
  };
}

class WidgetDeleteIntent extends Intent {
  const WidgetDeleteIntent();
}

class ToggleDrawingIntent extends Intent {
  const ToggleDrawingIntent();
}

class AddedTextIntent extends Intent {
  const AddedTextIntent();
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
