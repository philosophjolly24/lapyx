import 'package:flutter/material.dart';
import 'package:icarus/const/coordinate_system.dart';
import 'package:icarus/widgets/save_button.dart';
import 'package:icarus/widgets/tool_grid.dart';
import 'package:icarus/interactive_map.dart';
import 'package:icarus/sidebar.dart';

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
          Align(
            alignment: Alignment.topLeft,
            child: SaveButton(),
          ),
          SideBarUI()
        ],
      ),
    );
  }
}
