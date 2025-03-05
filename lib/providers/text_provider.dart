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

  void bringFoward(int index) {
    final newState = [...state];

    final temp = newState.removeAt(index);

    state = [...newState, temp];
  }

  void removeText(int index) {
    final newState = [...state];
    newState.removeAt(index);
    state = newState;
  }
}
