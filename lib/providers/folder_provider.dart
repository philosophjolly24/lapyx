import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:icarus/const/custom_icons.dart';
import 'package:icarus/const/hive_boxes.dart';
import 'package:icarus/providers/strategy_provider.dart';
import 'package:uuid/uuid.dart';

class Folder extends HiveObject {
  String name;
  final String id;
  final DateTime dateCreated;
  String? parentID; // null for root folders, clearer than empty string

  Folder({
    required this.name,
    required this.id,
    required this.dateCreated,
    this.parentID, // Optional, defaults to null (root)
  });

  static List<IconData> folderIcons = [
    // 📂 Folder & File Related
    Icons.folder,
    Icons.folder_open,
    Icons.create_new_folder,
    Icons.drive_folder_upload,
    Icons.folder_shared,
    Icons.folder_special,
    Icons.workspaces,
    Icons.inventory_2,

    // 🗂️ Organization & Structure
    Icons.category,
    Icons.collections_bookmark,
    Icons.library_books,
    Icons.archive,
    Icons.assignment,
    Icons.assignment_turned_in,
    Icons.dashboard,
    Icons.view_list,
    Icons.view_module,
    Icons.view_quilt,

    // 🎯 Strategy & Planning
    Icons.map,
    Icons.place,
    Icons.explore,
    Icons.explore_off,
    Icons.flag,
    Icons.outlined_flag,
    Icons.emoji_objects,
    Icons.lightbulb,
    Icons.track_changes,
    Icons.timeline,

    // ⚔️ Valorant / Tactical Feel
    Icons.sports_esports,
    CustomIcons.sword,
    Icons.military_tech,
    Icons.shield,
    Icons.security,
    Icons.bolt,
    Icons.psychology,
  ];

  bool get isRoot => parentID == null;
}

final folderProvider =
    NotifierProvider<FolderProvider, String?>(FolderProvider.new);

class FolderProvider extends Notifier<String?> {
  Future<void> createFolder() async {
    final newFolder = Folder(
      name: "test",
      id: const Uuid().v4(),
      dateCreated: DateTime.now(),
      parentID: state,
    );

    await Hive.box<Folder>(HiveBoxNames.foldersBox)
        .put(newFolder.id, newFolder);
  }

  void updateID(String? id) {
    state = id;
  }

  void clearID() {
    state = null;
  }

  void deleteFolder(String folderID) async {
    // state = state.where((folder) => folder.id != folderID).toList();

    final strategyList =
        Hive.box<StrategyData>(HiveBoxNames.strategiesBox).values.toList();

    List<String> idsToDelete = [];

    for (final strategy in strategyList) {
      if (strategy.folderID == folderID) {
        idsToDelete.add(strategy.id);
      }
    }

    for (final id in idsToDelete) {
      await Hive.box<StrategyData>(HiveBoxNames.strategiesBox).delete(id);
    }

    await Hive.box<Folder>(HiveBoxNames.foldersBox).delete(folderID);
  }

  @override
  String? build() {
    return null;
  }
}
