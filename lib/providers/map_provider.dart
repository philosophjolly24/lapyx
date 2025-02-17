import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/maps.dart';

final mapProvider = NotifierProvider<MapProvider, MapValue>(MapProvider.new);

class MapProvider extends Notifier<MapValue> {
  @override
  MapValue build() {
    return MapValue.ascent;
  }

  void updateMap(MapValue map) => state = map;

  String toJson() {
    return '"${Maps.maps[state]}"';
  }

  void fromJson(String json) {
    final mapName = jsonDecode(json);

    final mapValue =
        Maps.maps.entries.firstWhere((entry) => entry.value == mapName).key;

    state = mapValue;
  }
}
