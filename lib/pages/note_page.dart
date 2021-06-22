import 'package:desk/app_state.dart';
import 'package:desk/models/note.dart';
import 'package:flutter/material.dart';
import 'package:desk/blocs/note_bloc.dart';
import 'package:desk/widgets/note_form.dart';

class NotePage extends StatefulWidget {
  final int id;

  NotePage(this.id);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late NoteBloc noteBloc;
  late Note note;

  @override
  void initState() {
    noteBloc = NoteBloc();
    noteBloc.find(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    noteBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<Note>(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (!snapshot.hasData) {
            return Container(color: Colors.red);
          }

          note = snapshot.data!;

          return NoteForm(
            note: note,
            onSave: () {
              noteBloc.update(note).then((bool value) {
                var snack;
                if (value) {
                  snack = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('Note was updated!'),
                  );
                } else {
                  snack = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Something went wrong!'),
                  );
                }

                ScaffoldMessenger.of(context).showSnackBar(snack);
              });
            },
          );
        },
        stream: noteBloc.note,
      ),
    );
  }
}
