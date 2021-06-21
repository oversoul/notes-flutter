import 'package:desk/router.dart';
import 'package:desk/app_state.dart';
import 'package:flutter/material.dart';
import 'package:desk/models/note.dart';
import 'package:desk/blocs/notes_bloc.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late NotesBloc notesBloc;

  @override
  void initState() {
    notesBloc = NotesBloc();
    notesBloc.getAllNotes();
    super.initState();
  }

  @override
  void dispose() {
    notesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppState().rootNavigator.currentState!.pushNamed('/add');
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<Note> records = snapshot.data!;

          return GridView.builder(
            padding: EdgeInsets.all(20),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black.withOpacity(.07)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        color: Colors.black.withOpacity(.03),
                      )
                    ],
                    color: Colors.white,
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      final id = records[index].id;
                      if (id == null) return;
                      ScreenArguments args = ScreenArguments(id);
                      AppState()
                          .rootNavigator
                          .currentState!
                          .pushNamed('/note', arguments: args);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: HexColor.fromHex(
                                  records[index].color,
                                ),
                                radius: 10,
                              ),
                              SizedBox(width: 10),
                              Text(
                                records[index].name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: records.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
          );
        },
        stream: notesBloc.notes,
      ),
    );
  }
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    String color = hexString.replaceAll('#', '0xFF');
    return Color(int.parse(color));
  }
}
