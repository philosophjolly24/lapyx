import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/routes.dart';
import 'package:icarus/providers/strategy_provider.dart';
import 'package:icarus/widgets/settings_tab.dart';
import 'package:icarus/widgets/strategy_save_icon_button.dart';

class SaveButtonAndLoad extends ConsumerWidget {
  const SaveButtonAndLoad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              // // Navigator.of(context).pushNamed(Routes.settings);
              // Navigator.of(context).push(
              //   PageRouteBuilder(
              //     opaque: false,
              //     // barrierColor: Colors.black54,
              //     pageBuilder: (_, __, ___) => const SettingsTab(),
              //   ),
              // );

              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  transitionDuration: const Duration(milliseconds: 250),
                  reverseTransitionDuration: const Duration(milliseconds: 200),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const SettingsTab();
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    // Slide from right to left on push, and left to right on pop
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(
                          -1, 0.0), // start off-screen to the right
                      end: Offset.zero, // end at normal position
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                      reverseCurve: Curves.easeOutCubic,
                    ));

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
          const AutoSaveButton(),
          IconButton(
            tooltip: "Export",
            onPressed: () async {
              await ref
                  .read(strategyProvider.notifier)
                  .exportFile(ref.read(strategyProvider).id);
            },
            icon: const Icon(Icons.file_upload),
          ),
        ],
      ),
    );
  }
}
