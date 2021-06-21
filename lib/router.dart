import 'package:desk/pages/add_note_page.dart';
import 'package:desk/pages/main_page.dart';
import 'package:desk/pages/note_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenArguments {
  final int id;
  ScreenArguments(this.id);
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(builder: (_) => MainPage());

      case '/add':
        return CupertinoPageRoute(builder: (_) => AddNotePage());

      case '/note':
        final args = settings.arguments as ScreenArguments;
        return CupertinoPageRoute(builder: (_) => NotePage(args.id));

      default:
        return CupertinoPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
