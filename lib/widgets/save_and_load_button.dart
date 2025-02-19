import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/providers/ability_provider.dart';
import 'package:icarus/providers/agent_provider.dart';
import 'package:icarus/providers/drawing_provider.dart';
import 'package:icarus/providers/map_provider.dart';

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
              String? outputFile = await FilePicker.platform.saveFile(
                dialogTitle: 'Please select an output file:',
                fileName: 'strategy.ica',
                allowedExtensions: [".ica"],
              );

              if (outputFile == null) return;
              final file = File(outputFile);

              String data = '''
                {
                "drawingData": ${ref.read(drawingProvider.notifier).toJson()},
                "agentData": ${ref.read(agentProvider.notifier).toJson()},
                "abilityData": ${ref.read(abilityProvider.notifier).toJson()},
                "mapData": ${ref.read(mapProvider.notifier).toJson()}
                }
              ''';

              file.writeAsStringSync(data);
            },
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: () async {
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
              ref
                  .read(agentProvider.notifier)
                  .fromJson(jsonEncode(json["agentData"]));
              ref
                  .read(abilityProvider.notifier)
                  .fromJson(jsonEncode(json["abilityData"]));
              ref
                  .read(mapProvider.notifier)
                  .fromJson(jsonEncode(json["mapData"]));
            },
            icon: const Icon(Icons.file_open),
          ),
          IconButton(
            onPressed: () async {
              log(ref.read(agentProvider.notifier).toString());
            },
            icon: const Icon(Icons.bug_report),
          ),
        ],
      ),
    );
  }
}
