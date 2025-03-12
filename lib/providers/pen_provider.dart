import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/settings.dart';

enum PenMode { line, freeDraw, square }

class PenState {
  final Color color;

  final bool hasArrow;
  final bool isDotted;

  final double opacity;
  final double thickness;
  final PenMode penMode;

  PenState({
    required this.color,
    required this.hasArrow,
    required this.isDotted,
    required this.opacity,
    required this.thickness,
    required this.penMode,
  });

  PenState copyWith({
    Color? color,
    bool? hasArrow,
    bool? isDotted,
    double? opacity,
    double? thickness,
    PenMode? penMode,
  }) {
    return PenState(
      penMode: penMode ?? this.penMode,
      color: color ?? this.color,
      hasArrow: hasArrow ?? this.hasArrow,
      isDotted: isDotted ?? this.hasArrow,
      opacity: opacity ?? this.opacity,
      thickness: thickness ?? this.thickness,
    );
  }
}

class PenProvider extends Notifier<PenState> {
  @override
  PenState build() {
    return PenState(
      penMode: PenMode.freeDraw,
      color: Colors.white,
      hasArrow: false,
      isDotted: false,
      opacity: 1,
      thickness: Settings.brushSize,
    );
  }

  void updateValue({
    Color? color,
    bool? hasArrow,
    bool? isDotted,
    double? opacity,
    double? thickness,
    PenMode? penMode,
  }) {
    state = state.copyWith(
      color: color,
      hasArrow: hasArrow,
      isDotted: isDotted,
      opacity: opacity,
      thickness: thickness,
      penMode: penMode,
    );
  }
}
