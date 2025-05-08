import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cross_file/cross_file.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/hive_boxes.dart';
import 'package:icarus/const/settings.dart';
import 'package:icarus/providers/ability_provider.dart';
import 'package:icarus/providers/action_provider.dart';
import 'package:icarus/providers/agent_provider.dart';
import 'package:icarus/providers/auto_save_notifier.dart';
import 'package:icarus/providers/drawing_provider.dart';
import 'package:icarus/providers/image_provider.dart';
import 'package:icarus/providers/map_provider.dart';
import 'package:icarus/providers/text_provider.dart';
import 'package:hive_ce/hive.dart';
import 'package:icarus/const/drawing_element.dart';
import 'package:icarus/const/maps.dart';
import 'package:icarus/const/placed_classes.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StrategyData extends HiveObject {
  final String id;
  final String name;
  final int versionNumber;
  final List<DrawingElement> drawingData;
  final List<PlacedAgent> agentData;
  final List<PlacedAbility> abilityData;
  final List<PlacedText> textData;
  final List<PlacedImage> imageData;
  final MapValue mapData;
  final DateTime lastEdited;

  StrategyData({
    required this.id,
    required this.name,
    required this.drawingData,
    required this.agentData,
    required this.abilityData,
    required this.textData,
    required this.imageData,
    required this.mapData,
    required this.versionNumber,
    required this.lastEdited,
  });
}

class StrategyState {
  StrategyState({
    required this.isSaved,
    required this.stratName,
    required this.id,
    required this.storageDirectory,
  });
  final bool isSaved;
  final String? stratName;
  final String id;
  final String? storageDirectory;

  StrategyState copyWith(
      {bool? isSaved,
      String? stratName,
      String? id,
      String? storageDirectory}) {
    return StrategyState(
      isSaved: isSaved ?? this.isSaved,
      stratName: stratName ?? this.stratName,
      id: id ?? this.id,
      storageDirectory: storageDirectory ?? this.storageDirectory,
    );
  }
}

final strategyProvider =
    NotifierProvider<StrategyProvider, StrategyState>(StrategyProvider.new);

class StrategyProvider extends Notifier<StrategyState> {
  @override
  StrategyState build() {
    return StrategyState(
      isSaved: false,
      stratName: null,
      id: "testID",
      storageDirectory: null,
    );
  }

  Timer? _saveTimer;

  void setUnsaved() async {
    state = state.copyWith(isSaved: false);
    _saveTimer?.cancel();
    _saveTimer = Timer(Settings.autoSaveOffset, () async {
      //Find some way to tell the user that it is saving now()
      ref.read(autoSaveProvider.notifier).ping();
      await saveToHive(state.id);
    });
  }

  Future<void> setStorageDirectory() async {
    final strategyID = state.id;
    // Get the system's application support directory.
    final directory = await getApplicationSupportDirectory();

    // Create a custom directory inside the application support directory.

    final customDirectory = Directory(path.join(directory.path, strategyID));

    if (!await customDirectory.exists()) {
      await customDirectory.create(recursive: true);
    }

    state = state.copyWith(storageDirectory: customDirectory.path);
  }

  Future<void> loadFromHive(String id) async {
    final newStrat = Hive.box<StrategyData>(HiveBoxNames.strategiesBox)
        .values
        .where((StrategyData strategy) {
      return strategy.id == id;
    }).firstOrNull;

    if (newStrat == null) {
      log("Couldn't find save");
      return;
    }

    ref.read(agentProvider.notifier).fromHive(newStrat.agentData);
    ref.read(abilityProvider.notifier).fromHive(newStrat.abilityData);
    ref.read(drawingProvider.notifier).fromHive(newStrat.drawingData);
    ref.read(mapProvider.notifier).updateMap(newStrat.mapData);
    ref.read(textProvider.notifier).fromHive(newStrat.textData);
    ref.read(placedImageProvider.notifier).fromHive(newStrat.imageData);
    ref.read(actionProvider.notifier).clearAllActions();

    state = StrategyState(
      isSaved: true,
      stratName: newStrat.name,
      id: newStrat.id,
      storageDirectory: state.storageDirectory,
    );
    await setStorageDirectory();
  }

  Future<void> loadFromFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ["ica"],
    );

    if (result == null) return;

    for (PlatformFile file in result.files) {
      await _loadFromXFile(file.xFile);
    }
  }

  Future<void> loadFromFileDrop(List<XFile> files) async {
    for (XFile file in files) {
      await _loadFromXFile(file);
    }
  }

  Future<void> _loadFromXFile(XFile file) async {
    if (path.extension(file.path) != ".ica") return;

    final data = await file.readAsString();

    Map<String, dynamic> json = jsonDecode(data);

    final newID = const Uuid().v4();

    final List<DrawingElement> drawingData = ref
        .read(drawingProvider.notifier)
        .fromJson(jsonEncode(json["drawingData"]));
    List<PlacedAgent> prevAgentData = ref
        .read(agentProvider.notifier)
        .fromJson(jsonEncode(json["agentData"]));

    List<PlacedAgent> agentData = [];
    for (PlacedAgent agent in prevAgentData) {
      agent.position = agent.position.translate(-2.6, -16.9);
      agentData.add(agent);
    }
    final List<PlacedAbility> abilityData = ref
        .read(abilityProvider.notifier)
        .fromJson(jsonEncode(json["abilityData"]));

    final mapData =
        ref.read(mapProvider.notifier).fromJson(jsonEncode(json["mapData"]));
    final textData =
        ref.read(textProvider.notifier).fromJson(jsonEncode(json["textData"]));

    final imageData = await ref.read(placedImageProvider.notifier).fromJson(
        jsonString: jsonEncode(json["imageData"] ?? []), strategyID: newID);

    final newStrategy = StrategyData(
      id: newID,
      name: path.basenameWithoutExtension(file.name),
      drawingData: drawingData,
      agentData: agentData,
      abilityData: abilityData,
      textData: textData,
      imageData: imageData,
      mapData: mapData,
      versionNumber: Settings.versionNumber,
      lastEdited: DateTime.now(),
    );
    await Hive.box<StrategyData>(HiveBoxNames.strategiesBox)
        .put(newStrategy.id, newStrategy);
  }

  Future<void> createNewStrategy(String name) async {
    final newID = const Uuid().v4();
    final newStrategy = StrategyData(
      drawingData: [],
      agentData: [],
      abilityData: [],
      textData: [],
      imageData: [],
      mapData: MapValue.ascent,
      versionNumber: Settings.versionNumber,
      id: newID,
      name: name,
      lastEdited: DateTime.now(),
    );

    await Hive.box<StrategyData>(HiveBoxNames.strategiesBox)
        .put(newStrategy.id, newStrategy);
  }

  Future<void> exportFile(String id) async {
    await saveToHive(id);
    String fetchedImageData =
        await ref.read(placedImageProvider.notifier).toJson(id);
    String data = '''
                {
                "versionNumber": "${Settings.versionNumber}",
                "drawingData": ${ref.read(drawingProvider.notifier).toJson()},
                "agentData": ${ref.read(agentProvider.notifier).toJson()},
                "abilityData": ${ref.read(abilityProvider.notifier).toJson()},
                "textData": ${ref.read(textProvider.notifier).toJson()},
                "mapData": ${ref.read(mapProvider.notifier).toJson()},
                "imageData":$fetchedImageData
                }
              ''';

    File file;
    // log("File name: ${state.fileName}");

    String? outputFile = await FilePicker.platform.saveFile(
      type: FileType.custom,
      dialogTitle: 'Please select an output file:',
      fileName: "${state.stratName ?? "new strategy"}.ica",
      allowedExtensions: [".ica"],
    );

    if (outputFile == null) return;
    file = File(outputFile);

    file.writeAsStringSync(data);
    // state = state.copyWith(fileName: file.path, isSaved: true);
  }

  Future<void> deleteStrategy(String strategyID) async {
    await Hive.box<StrategyData>(HiveBoxNames.strategiesBox).delete(strategyID);
  }

  Future<void> saveToHive(String id) async {
    final drawingData = ref.read(drawingProvider).elements;
    final agentData = ref.read(agentProvider);
    final abilityData = ref.read(abilityProvider);
    final textData = ref.read(textProvider);
    final mapData = ref.read(mapProvider);
    final imageData = ref.read(placedImageProvider).images;

    final currentStategy = StrategyData(
      drawingData: drawingData,
      agentData: agentData,
      abilityData: abilityData,
      textData: textData,
      imageData: imageData,
      mapData: mapData,
      versionNumber: 1,
      id: id,
      name: state.stratName ?? "placeholder",
      lastEdited: DateTime.now(),
    );

    await Hive.box<StrategyData>(HiveBoxNames.strategiesBox)
        .put(currentStategy.id, currentStategy);
  }
}
