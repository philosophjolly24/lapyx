import 'package:flutter/material.dart';
import 'package:icarus/DrawingElement.dart';
import 'package:icarus/interactive_map.dart';
import 'package:icarus/main.dart';
import 'package:icarus/providers/drawing_provider.dart';
import 'package:provider/provider.dart';

class InteractivePainter extends StatefulWidget {
  final Size playAreaSize;
  const InteractivePainter({super.key, required this.playAreaSize});

  @override
  State<InteractivePainter> createState() => _InteractivePainterState();
}

class _InteractivePainterState extends State<InteractivePainter> {
  @override
  Widget build(BuildContext context) {
    CoordinateSystem coordinateSystem =
        CoordinateSystem(playAreaSize: widget.playAreaSize);

    // Get the drawing data here in the widget
    final drawingProvider = context.watch<DrawingProvider>();

    CustomPainter drawingPainter = DrawingPainter(
      updateCounter: drawingProvider.updateCounter,
      coordinateSystem: coordinateSystem,
      elements: drawingProvider.listOfElements, // Pass the data directly
    );

    return GestureDetector(
      onPanStart: (details) {
        Offset lineStart =
            coordinateSystem.screenToCoordinate(details.localPosition);
        drawingProvider.startLine(lineStart);
      },
      onPanUpdate: (details) {
        Offset lineEnd =
            coordinateSystem.screenToCoordinate(details.localPosition);

        drawingProvider.updateCurrentLine(lineEnd);
      },
      onPanEnd: (details) {
        Offset lineEnd =
            coordinateSystem.screenToCoordinate(details.localPosition);
        drawingProvider.finishCurrentLine(lineEnd);
      },
      child: CustomPaint(
        painter: drawingPainter,
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final CoordinateSystem coordinateSystem;
  final List<DrawingElement> elements; // Store the drawing elements
  final int updateCounter;

  DrawingPainter({
    required this.updateCounter,
    required this.coordinateSystem,
    required this.elements,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < elements.length; i++) {
      if (elements[i] is Line) {
        Line line = elements[i] as Line;
        Offset screenStartOffset =
            coordinateSystem.coordinateToScreen(line.lineStart);
        Offset screenEndOffset =
            coordinateSystem.coordinateToScreen(line.lineEnd);
        canvas.drawLine(screenStartOffset, screenEndOffset, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.updateCounter !=
        updateCounter; // Repaint when elements change
  }
}
