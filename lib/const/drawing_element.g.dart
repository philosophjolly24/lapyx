// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawing_element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreeDrawing _$FreeDrawingFromJson(Map<String, dynamic> json) => FreeDrawing(
      listOfPoints: _$JsonConverterFromJson<List<dynamic>, List<Offset>>(
          json['listOfPoints'], const OffsetListConverter().fromJson),
      color: const ColorConverter().fromJson(json['color'] as String),
    );

Map<String, dynamic> _$FreeDrawingToJson(FreeDrawing instance) =>
    <String, dynamic>{
      'color': const ColorConverter().toJson(instance.color),
      'listOfPoints': const OffsetListConverter().toJson(instance.listOfPoints),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
