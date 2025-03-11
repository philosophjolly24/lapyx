import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShortcutInfo {
  static final Map<ShortcutActivator, Intent> widgetShortcuts = {
    LogicalKeySet(LogicalKeyboardKey.keyX): const WidgetDeleteIntent()
  };
}

class WidgetDeleteIntent extends Intent {
  const WidgetDeleteIntent();
}
