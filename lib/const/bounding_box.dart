import 'dart:ui';

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:icarus/const/json_converters.dart';
import 'package:json_annotation/json_annotation.dart';
part 'bounding_box.g.dart';

@JsonSerializable()
class BoundingBox extends HiveObject {
  @OffsetConverter()
  final Offset min;

  @OffsetConverter()
  final Offset max;

  BoundingBox({required this.min, required this.max});

  bool isWithin(Offset position) {
    if (position.dx >= min.dx &&
        position.dx <= max.dx &&
        position.dy >= min.dy &&
        position.dy <= max.dy) {
      return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() => _$BoundingBoxToJson(this);

  factory BoundingBox.fromJson(Map<String, dynamic> json) =>
      _$BoundingBoxFromJson(json);

  @override
  String toString() {
    return 'BoundingBox(min: $min, max: $max)';
  }
}
