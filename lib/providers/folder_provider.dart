import 'package:hive_ce_flutter/adapters.dart';
import 'package:icarus/const/hive_boxes.dart';
import 'package:icarus/providers/strategy_provider.dart';

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

  bool get isRoot => parentID == null;
}

class FolderProvider {
  static Future<void> createFolder(Folder folder) async {
    await Hive.box<Folder>(HiveBoxNames.foldersBox).put(folder.id, folder);
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
}
