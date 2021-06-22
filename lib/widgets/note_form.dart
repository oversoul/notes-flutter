import 'dart:convert';
import 'package:desk/app_state.dart';
import 'package:desk/models/note.dart';
import 'package:flutter/material.dart';
import 'package:desk/content/text.dart';
import 'package:desk/content/checkbox.dart';
import 'package:desk/pages/main_page.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class NoteForm extends StatefulWidget {
  final Note note;
  final void Function() onSave;

  NoteForm({required this.note, required this.onSave});

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  late Note note;
  late List models;
  final nameController = TextEditingController();

  @override
  void initState() {
    note = widget.note;
    nameController.text = note.name;
    var body = json.decode(note.body);
    models = jsonToContent(body);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = HexColor.fromHex(note.color);
    final textColor =
        color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          color: textColor,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            AppState()
              .rootNavigator
              .currentState!
              .pushNamedAndRemoveUntil('/', (_) => false)
              .then((value) => setState(() {}));
          },
        ),
        title: Text(
          nameController.text,
          style: TextStyle(color: textColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.color_lens),
            color: textColor,
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => colorPickerDialog(context, color),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            color: textColor,
            onPressed: () {
              var body = [];
              for (var widget in models) {
                body.add(widget.model.toJson());
              }

              note.name = nameController.text;
              note.body = json.encode(body);
              widget.onSave();
            },
          ),
        ],
        backgroundColor: color,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: nameController,
            onChanged: (v) { setState(() {}); },
            style: TextStyle(fontSize: 32),
          ),
          ...models,
        ],
      ),
    );
  }

  Widget colorPickerDialog(BuildContext context, Color color) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColorPicker(
            color: color,
            width: 40,
            height: 40,
            spacing: 10,
            runSpacing: 10,
            borderRadius: 4,
            wheelDiameter: 240,
            heading: Text('Select color'),
            onColorChanged: (Color color) {
              setState(() => note.color = "#${color.hex}");
            },
            pickersEnabled: <ColorPickerType, bool>{
              ColorPickerType.wheel: true,
              ColorPickerType.accent: false,
              ColorPickerType.primary: false,
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Ok'),
        ),
      ],
    );
  }
}


List jsonToContent(List content) {
  List models = [];
  for(var item in content) {
    switch (item['name']) {
      case 'TextWidget':
        models.add(TextWidget(
          model: TextWidgetModel.fromMap(item)
        ));
        break;
      case 'CheckboxWidget':
        models.add(CheckboxWidget(
          model: CheckboxWidgetModel.fromMap(item)
        ));
        break;
      default:
    }
  }
  
  return models;
}