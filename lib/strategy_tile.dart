import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/strategy_provider.dart';

class StrategyTile extends ConsumerWidget {
  const StrategyTile({
    super.key,
    required this.strategyData,
  });

  final StrategyData strategyData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 612,
      height: 461,
      decoration: BoxDecoration(
        color: Settings.sideBarColor,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        border: Border.all(color: Settings.highlightColor),
      ),
      child: Column(
        children: [Image.asset("")],
      ),
    );
  }
}
