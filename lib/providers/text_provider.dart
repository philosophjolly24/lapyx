import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/const/placed_classes.dart';

final textProvider =
    NotifierProvider<TextProvider, List<PlacedText>>(TextProvider.new);

class TextProvider extends Notifier<List<PlacedText>> {
  @override
  List<PlacedText> build() {
    return [];
  }

  void addText(PlacedText text) {
    state = [...state, text];
  }

  void bringFoward(String id) {
    final newState = [...state];

    int index = PlacedWidget.getIndexByID(id, newState);
    if (index < 0) return;
    final temp = newState.removeAt(index);

    state = [...newState, temp];
  }

  void editText(String text, String id) {
    final newState = [...state];

    newState
        .firstWhere(
          (element) => element.id == id,
        )
        .text = text;
    // newState[index].text = text;
    state = newState;
  }

  void removeText(String id) {
    final newState = [...state];
    final index = PlacedWidget.getIndexByID(id, newState);
    newState.removeAt(index);
    state = newState;
  }

  String toJson() {
    final List<Map<String, dynamic>> jsonList =
        state.map((text) => text.toJson()).toList();
    return jsonEncode(jsonList);
  }

  void fromJson(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    state = jsonList
        .map((json) => PlacedText.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
