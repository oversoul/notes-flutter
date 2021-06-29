import 'package:desk/app_state.dart';
import 'package:desk/models/note.dart';
import 'package:flutter/material.dart';
import 'package:desk/pages/main_page.dart';
import 'package:desk/content/widgetable_content.dart';
import 'package:desk/widgets/popup_menu/popup_menu.dart';
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
  final content = WidgetableContent();
  GlobalKey addButtonKey = GlobalKey();
  final nameController = TextEditingController();

  @override
  void initState() {
    note = widget.note;
    nameController.text = note.name;

    content.encode(note.body);

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
              note.name = nameController.text;
              note.body = content.decode();
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
            onChanged: (v) {
              setState(() {});
            },
            style: TextStyle(fontSize: 32),
          ),
          ...content.models,
          MaterialButton(
            height: 45.0,
            key: addButtonKey,
            child: Text('Show Menu'),
            onPressed: addWidgetMenu,
          ),
        ],
      ),
    );
  }

  void addWidgetMenu() {
    PopupMenu menu = PopupMenu(
      maxColumn: 2,
      context: context,
      items: [
        MenuItem(
          title: 'Text',
          userInfo: 'TextWidget',
          image: Icon(Icons.text_fields, color: Colors.white),
        ),
        MenuItem(
          title: 'Check Box List',
          userInfo: 'CheckboxWidget',
          image: Icon(Icons.check_box, color: Colors.white),
        ),
      ],
      onClickMenu: (MenuItemProvider item) {
        content.addBlankWidgetFromString(item.userInfo);
        setState(() {});
      },
      // stateChanged: stateChanged,
      // onDismiss: onDismiss,
    );
    menu.show(widgetKey: addButtonKey);
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
