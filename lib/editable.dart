import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'editable.g.dart';

@riverpod
class Editable extends _$Editable {
  @override
  bool build() => true;

  void change() {
    state = !state;
  }
}
