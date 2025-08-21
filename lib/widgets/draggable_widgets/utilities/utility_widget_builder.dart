import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/placed_classes.dart';

class UtilityWidgetBuilder extends ConsumerStatefulWidget {
  final PlacedUtility utility;
  final Function(DraggableDetails details) onDragEnd;
  final String id;
  final PlacedWidget data;
  final double rotation;
  final double length;
  const UtilityWidgetBuilder({
    required this.utility,
    required this.onDragEnd,
    required this.id,
    required this.data,
    required this.rotation,
    required this.length,
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UtilityWidgetBuilderState();
}

class _UtilityWidgetBuilderState extends ConsumerState<UtilityWidgetBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
