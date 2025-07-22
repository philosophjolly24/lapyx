enum MapValue {
  ascent,
  breeze,
  lotus,
  icebox,
  sunset,
  split,
  haven,
  fracture,
  abyss,
  pearl,
  bind,
  corrode,
}

class Maps {
  static List<MapValue> availableMaps = [
    MapValue.ascent,
    MapValue.bind,
    MapValue.haven,
    MapValue.icebox,
    MapValue.lotus,
    MapValue.corrode,
    MapValue.split,
  ];

  static List<MapValue> outofplayMaps = [
    MapValue.pearl,
    MapValue.fracture,
  ];

  static Map<MapValue, String> mapNames = {
    MapValue.ascent: 'ascent',
    MapValue.breeze: 'breeze',
    MapValue.lotus: 'lotus',
    MapValue.icebox: 'icebox',
    MapValue.sunset: 'sunset',
    MapValue.split: 'split',
    MapValue.haven: 'haven',
    MapValue.fracture: 'fracture',
    MapValue.abyss: 'abyss',
    MapValue.pearl: 'pearl',
    MapValue.bind: 'bind',
    MapValue.corrode: 'corrode',
  };

  static Map<MapValue, double> mapScale = {
    MapValue.ascent: 1,
    MapValue.breeze: 1,
    MapValue.lotus: 2,
    MapValue.icebox: 1,
    MapValue.sunset: 1,
    MapValue.split: 1,
    MapValue.haven: 1,
    MapValue.fracture: 1,
    MapValue.abyss: 1,
    MapValue.pearl: 1,
    MapValue.bind: 1,
    MapValue.corrode: 1,
  };
}
