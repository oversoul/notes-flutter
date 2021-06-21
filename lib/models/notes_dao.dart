import 'package:desk/app_state.dart';
import 'package:sembast/sembast.dart';
import 'package:desk/models/note.dart';

class NoteDao {
  final _store = intMapStoreFactory.store();

  Future<int> insert(Note note) async {
    return await _store.add(AppState().db, note.toMap());
  }

  Future<void> update(Note note) async {
    print("key: ${note.id}");
    await _store.record(note.id!).update(AppState().db, note.toMap());
  }

  Future delete(Note note) async {
    final finder = Finder(filter: Filter.equals('id', note.id));
    await _store.delete(AppState().db, finder: finder);
  }

  Future<List<Note>> getAll() async {
    final finder = Finder(sortOrders: [SortOrder(Field.key, false)]);
    final records = await _store.find(AppState().db, finder: finder);

    return records.map((snapshot) {
      final note = Note.fromMap(snapshot.value);
      note.id = snapshot.key;
      return note;
    }).toList();
  }

  Future<Note> getByKey(int id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    final record = await _store.findFirst(AppState().db, finder: finder);
    if (record == null) return Note(name: '', color: '', body: '');
    final note = Note.fromMap(record.value);
    note.id = record.key;
    return note;
  }
}
