import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icarus/const/color_option.dart';

class Settings {
  static const double agentSize = 30;
  static const double abilitySize = 25;
  static const Color abilityBGColor = Color(0xFF1B1B1B);

  static const double brushSize = 5;
  static const PhysicalKeyboardKey deleteKey = PhysicalKeyboardKey.keyX;

  static const Color sideBarColor = Color(0xFF141114);
  static const Color highlightColor = Color.fromRGBO(210, 214, 219, 0.102);
  static List<ColorOption> penColors = [
    ColorOption(color: Colors.white, isSelected: true),
    ColorOption(color: Colors.red, isSelected: false),
    ColorOption(color: Colors.blue, isSelected: false),
    ColorOption(color: Colors.yellow, isSelected: false),
    ColorOption(color: Colors.green, isSelected: false),
  ];

  static const Color enemyBGColor = Color.fromARGB(255, 119, 39, 39);
  static const Color allyBGColor = Color.fromARGB(255, 58, 126, 93);

  static const Color enemyOutlineColor = Color.fromARGB(139, 255, 82, 82);
  static const Color allyOutlineColor = Color.fromARGB(106, 105, 240, 175);

  static final Uri dicordLink = Uri.parse("https://discord.gg/PN2uKwCqYB");

  static const Duration autoSaveOffset = Duration(seconds: 5);
  static const int versionNumber = 1;
}
