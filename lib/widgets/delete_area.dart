import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/coordinate_system.dart';

class DeleteArea extends ConsumerWidget {
  const DeleteArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: CoordinateSystem.instance.scale(20),
    );
  }
}
