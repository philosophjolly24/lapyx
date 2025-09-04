import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/adapters.dart';
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
