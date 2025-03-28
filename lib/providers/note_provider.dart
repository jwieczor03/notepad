import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';

class NoteNotifier extends StateNotifier<List<Note>> {
  NoteNotifier() : super([]);

  void addNote(Note note) {
    state = [...state, note];
  }

  void updateNote(int index, Note note) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) note else state[i],
    ];
  }

  void deleteNote(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
  }
}

final noteProvider = StateNotifierProvider<NoteNotifier, List<Note>>((ref) {
  return NoteNotifier();
});
