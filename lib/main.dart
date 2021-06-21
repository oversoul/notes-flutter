import 'dart:async';

import 'package:desk/app_state.dart';
import 'package:desk/app_wrapper.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await AppState().asyncInit();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      home: AppWrapper(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
