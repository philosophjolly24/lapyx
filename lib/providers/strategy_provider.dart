import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/ability_provider.dart';
import 'package:icarus/providers/agent_provider.dart';
import 'package:icarus/providers/drawing_provider.dart';
import 'package:icarus/providers/image_provider.dart';
import 'package:icarus/providers/map_provider.dart';
import 'package:icarus/providers/text_provider.dart';

class StrategyData {
  StrategyData({required this.isSaved, required this.fileName});
  final bool isSaved;
  final String? fileName;

  StrategyData copyWith({
    bool? isSaved,
    String? fileName,
  }) {
    return StrategyData(
      isSaved: isSaved ?? this.isSaved,
      fileName: fileName ?? this.fileName,
    );
  }
}

final strategyProvider =
    NotifierProvider<StrategyProvider, StrategyData>(StrategyProvider.new);

class StrategyProvider extends Notifier<StrategyData> {
  @override
  StrategyData build() {
    return StrategyData(isSaved: false, fileName: null);
  }

  void setFileStatus(bool status) {
    state = state.copyWith(isSaved: status);
  }

  Future<void> loadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ["ica"],
    );

    if (result == null) return;
    final data = await result.files.first.xFile.readAsString();

    Map<String, dynamic> json = jsonDecode(data);

    ref
        .read(drawingProvider.notifier)
        .fromJson(jsonEncode(json["drawingData"]));
    ref.read(agentProvider.notifier).fromJson(jsonEncode(json["agentData"]));
    ref
        .read(abilityProvider.notifier)
        .fromJson(jsonEncode(json["abilityData"]));
    ref.read(mapProvider.notifier).fromJson(jsonEncode(json["mapData"]));
    ref.read(textProvider.notifier).fromJson(jsonEncode(json["textData"]));

    ref
        .read(placedImageProvider.notifier)
        .fromJson(jsonEncode(json["imageData"]));
    state = state.copyWith(fileName: result.files.first.path, isSaved: true);
  }

  Future<void> saveFile() async {
    String data = '''
                {
                "drawingData": ${ref.read(drawingProvider.notifier).toJson()},
                "agentData": ${ref.read(agentProvider.notifier).toJson()},
                "abilityData": ${ref.read(abilityProvider.notifier).toJson()},
                "textData": ${ref.read(textProvider.notifier).toJson()},
                "mapData": ${ref.read(mapProvider.notifier).toJson()},
                "imageData":${ref.read(placedImageProvider.notifier).toJson()}
                }
              ''';

    File file;
    log("File name: ${state.fileName}");

    if (state.fileName != null) {
      file = File(state.fileName!);

      if (file.existsSync()) {
        file.writeAsStringSync(data);
        state = state.copyWith(isSaved: false);
        return;
      }
    }

    String? outputFile = await FilePicker.platform.saveFile(
      type: FileType.custom,
      dialogTitle: 'Please select an output file:',
      fileName: 'strategy.ica',
      allowedExtensions: [".ica"],
    );

    if (outputFile == null) return;
    file = File(outputFile);

    file.writeAsStringSync(data);
    state = state.copyWith(fileName: file.path, isSaved: true);
  }
}
