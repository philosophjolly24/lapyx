// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawing_element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreeDrawing _$FreeDrawingFromJson(Map<String, dynamic> json) => FreeDrawing()
  ..listOfPoints =
      const OffsetListConverter().fromJson(json['listOfPoints'] as List);

Map<String, dynamic> _$FreeDrawingToJson(FreeDrawing instance) =>
    <String, dynamic>{
      'listOfPoints': const OffsetListConverter().toJson(instance.listOfPoints),
    };
