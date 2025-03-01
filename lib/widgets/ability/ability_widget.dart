import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/ability_provider.dart';
import 'package:icarus/widgets/mouse_watch.dart';

class AbilityWidget extends ConsumerWidget {
  const AbilityWidget({
    super.key,
    required this.iconPath,
    required this.index,
  });
  final int? index;
  final String iconPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coordinateSystem = CoordinateSystem.instance;

    return MouseWatch(
      onDeleteKeyPressed: () {
        if (index == null) return;
        ref.read(abilityProvider.notifier).removeAbility(index!);
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        child: Container(
          width: coordinateSystem.scale(Settings.abilitySize),
          height: coordinateSystem.scale(Settings.abilitySize),
          padding: EdgeInsets.all(coordinateSystem.scale(3)),
          decoration: const BoxDecoration(
            color: Settings.abilityBGColor,
          ),
          child: Image.asset(
            iconPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
