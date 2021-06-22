import 'package:desk/app_state.dart';
import 'package:desk/blocs/note_bloc.dart';
import 'package:desk/models/note.dart';
import 'package:desk/widgets/note_form.dart';
import 'package:flutter/material.dart';

class AddNotePage extends StatefulWidget {
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late NoteBloc noteBloc;
  Note note = Note(name: '', body: '[]', color: '#ffffff');

  @override
  void initState() {
    noteBloc = NoteBloc();
    super.initState();
  }

  @override
  void dispose() {
    noteBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NoteForm(
      note: note,
      onSave: () {
        noteBloc.create(note).then((int value) {
          var snack;
          if (value > 0) {
            note.id = value;
            noteBloc.update(note);
            snack = SnackBar(
              backgroundColor: Colors.green,
              content: Text('Note was created!'),
            );
          } else {
            snack = SnackBar(
              backgroundColor: Colors.red,
              content: Text('Something went wrong!'),
            );
          }

          ScaffoldMessenger.of(context).showSnackBar(snack);

          AppState()
              .rootNavigator
              .currentState!
              .pushNamedAndRemoveUntil('/', (_) => false)
              .then((value) => setState(() {}));
        });
      },
    );
  }
}
