import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

AppState appState = new AppState();

class AppState {
  static final AppState _singleton = AppState._internal();

  factory AppState() {
    return _singleton;
  }

  AppState._internal();

  late Database db;
  String dbPath = 'sample.db';
  // File path to a file in the current directory
  DatabaseFactory dbFactory = databaseFactoryIo;

  GlobalLoader globalLoader = GlobalLoader();
  GlobalKey<ScaffoldState> globalScaffold = GlobalKey<ScaffoldState>();
  GlobalKey<NavigatorState> rootNavigator = GlobalKey<NavigatorState>();

  Future<void> asyncInit() async {
    // We use the database factory to open the database
    db = await dbFactory.openDatabase(dbPath);
   
    // var store = intMapStoreFactory.store();
    // var key = await store.add(db, {
    //   'name': 'First note',
    //   'body': 'lorem ipsum like always....',
    //   'color': '#FF0000'
    // });
  }

  dispose() {
    db.close();
  }
}

class GlobalLoader {
  String text = "Loading...";
  bool visible = false;

  void show([String? message]) {
    visible = true;
    this.text = message ?? text;
    // AppState().cmdDisplayLoader.add(visible);
  }

  void hide() {
    visible = false;
    // AppState().cmdDisplayLoader.add(visible);
  }
}
