import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icarus/const/color_option.dart';

class Settings {
  static const double agentSize = 30;
  static const double abilitySize = 30;
  static const Color abilityBGColor = Color(0xFF1B1B1B);

  static const double brushSize = 5;
  static const PhysicalKeyboardKey deleteKey = PhysicalKeyboardKey.keyX;

  static const Color sideBarColor = Color(0xFF141114);
  static const Color highlightColor = Color(0x1AD2D6DB);
  static List<ColorOption> penColors = [
    ColorOption(color: Colors.white, isSelected: true),
    ColorOption(color: Colors.red, isSelected: false),
    ColorOption(color: Colors.blue, isSelected: false),
    ColorOption(color: Colors.yellow, isSelected: false),
    ColorOption(color: Colors.green, isSelected: false),
  ];

  static final Uri dicordLink = Uri.parse("https://discord.gg/PN2uKwCqYB");
}
