import 'dart:async';
import 'package:desk/models/note.dart';
import 'package:desk/models/notes_dao.dart';

class NotesBloc {
  NoteDao _dao = NoteDao();

  StreamController<List<Note>> notesController = StreamController();

  Stream<List<Note>> get notes => notesController.stream;

  void getAllNotes() async {
    final notes = await _dao.getAll();
    notesController.sink.add(notes);
  }

  void dispose() {
    notesController.close();
  }

}
