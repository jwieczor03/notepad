import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required String title,
    required String content,
    required DateTime createdAt,
    required DateTime modifiedAt,
  }) = _Note;
}