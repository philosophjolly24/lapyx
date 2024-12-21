import 'package:flutter/material.dart';
import 'package:icarus/widgets/bottom_actionbar.dart';
import 'package:icarus/interactive_map.dart';
import 'package:icarus/outer_ui.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Strategy"),
      ),
      body: const Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [InteractiveMap()],
            ),
          ),
          BottomActionbar(),
          OuterUi()
        ],
      ),
    );
  }
}
