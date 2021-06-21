import 'dart:async';
import 'package:desk/models/note.dart';
import 'package:desk/models/notes_dao.dart';

class NoteBloc {
  NoteDao _dao = NoteDao();
  // StreamController<List<Note>> noteController = StreamController();
  StreamController<Note> noteController = StreamController();

  Stream<Note> get note => noteController.stream;

  // void getAllNotes() async {
  //   final notes = await _dao.getAll();
  //   noteController.sink.add(notes);
  // }

  void dispose() {
    noteController.close();
  }

  Future<int> create(Note note) async {
    return await _dao.insert(note);
  }

  void find(int id) async {
    final note = await _dao.getByKey(id);
    if (note.id == null) {
      noteController.sink.addError("Note not found.");
    } else {
      noteController.sink.add(note);
    }
  }

  Future<bool> update(Note note) async {
    final value = await _dao.update(note);
    // return value > 0;
    return true;
  }
}
