import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StrategyManager extends ConsumerWidget {
  const StrategyManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      itemCount: 10,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 268,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        if (index == 0) {
          return InkWell(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF151515),
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(height: 20),
                  Text("New Strategy")
                ],
              ),
            ),
            onTap: () {},
          );
        }
        return InkWell(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF151515),
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 193,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                      color: Colors.red,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Strategy 1"),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Ascent"),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {},
        );
      },
    );
  }
}
