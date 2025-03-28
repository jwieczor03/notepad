import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/note_provider.dart';
import 'models/note.dart';
import 'package:intl/intl.dart'; 

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notatnik',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NoteListScreen(),
    );
  }
}

class NoteListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(noteProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notatki'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showNoteDialog(context, ref);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.content),
                SizedBox(height: 4), 
                Text(
                  'Utworzono: ${DateFormat('yyyy-MM-dd – kk:mm').format(note.createdAt)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'Ostatnia modyfikacja: ${DateFormat('yyyy-MM-dd – kk:mm').format(note.modifiedAt)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            onTap: () {
              _showNoteDialog(context, ref, note: note, index: index);
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                ref.read(noteProvider.notifier).deleteNote(index);
              },
            ),
          );
        },
      ),
    );
  }

  void _showNoteDialog(
    BuildContext context,
    WidgetRef ref, {
    Note? note,
    int? index,
  }) {
    final titleController = TextEditingController(text: note?.title);
    final contentController = TextEditingController(text: note?.content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(note == null ? 'Dodaj nową notatkę' : 'Edytuj notatkę'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Tytuł'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Treść'),
                maxLines: 5,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Anuluj'),
            ),
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final content = contentController.text;

                if (title.isNotEmpty && content.isNotEmpty) {
                  final now = DateTime.now();
                  final newNote = Note(
                    title: title,
                    content: content,
                    createdAt: note?.createdAt ?? now,
                    modifiedAt: now,
                  );

                  if (note == null) {
                    ref.read(noteProvider.notifier).addNote(newNote);
                  } else {
                    ref
                        .read(noteProvider.notifier)
                        .updateNote(index!, newNote.copyWith(modifiedAt: now));
                  }

                  Navigator.of(context).pop();
                }
              },
              child: Text(note == null ? 'Dodaj ' : 'Zapisz'),
            ),
          ],
        );
      },
    );
  }
}
