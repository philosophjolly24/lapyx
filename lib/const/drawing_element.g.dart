// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawing_element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreeDrawing _$FreeDrawingFromJson(Map<String, dynamic> json) => FreeDrawing(
      color: const ColorConverter().fromJson(json['color'] as String),
      boundingBox: json['boundingBox'] == null
          ? null
          : BoundingBox.fromJson(json['boundingBox'] as Map<String, dynamic>),
      isDotted: json['isDotted'] as bool,
      hasArrow: json['hasArrow'] as bool,
      id: json['id'] as String,
    );

Map<String, dynamic> _$FreeDrawingToJson(FreeDrawing instance) =>
    <String, dynamic>{
      'color': const ColorConverter().toJson(instance.color),
      'isDotted': instance.isDotted,
      'hasArrow': instance.hasArrow,
      'id': instance.id,
      'boundingBox': instance.boundingBox,
    };
