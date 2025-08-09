import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/maps.dart';

final mapProvider = NotifierProvider<MapProvider, MapState>(MapProvider.new);

class MapState {
  final MapValue currentMap;
  final bool isAttack;

  MapState({required this.currentMap, required this.isAttack});

  MapState copyWith({MapValue? currentMap, bool? isAttack}) {
    return MapState(
      currentMap: currentMap ?? this.currentMap,
      isAttack: isAttack ?? this.isAttack,
    );
  }
}

class MapProvider extends Notifier<MapState> {
  @override
  MapState build() {
    return MapState(currentMap: MapValue.ascent, isAttack: true);
  }

  void updateMap(MapValue map) => state = state.copyWith(currentMap: map);

  void fromHive(MapValue map, bool isAttack) {
    state = state.copyWith(currentMap: map, isAttack: isAttack);
  }

  void switchSide() {
    state = state.copyWith(isAttack: !state.isAttack);
  }

  String toJson() {
    return '"${Maps.mapNames[state.currentMap]}"';
  }

  MapValue fromJson(String json) {
    final mapName = jsonDecode(json);

    final mapValue =
        Maps.mapNames.entries.firstWhere((entry) => entry.value == mapName).key;

    return mapValue;
  }
}
