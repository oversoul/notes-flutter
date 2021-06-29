import 'package:flutter/material.dart';

class CheckboxWidget extends StatefulWidget {
  final CheckboxWidgetModel model;

  CheckboxWidget({Key? key, required this.model}) : super(key: key);

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ...buildLines(),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              widget.model.lines.add(
                CheckLine.fromMap({'checked': false, 'content': ''}),
              );

              setState(() => widget.model.save());
            },
          ),
        ],
      ),
    );
  }

  List<Widget> buildLines() {
    List<Widget> lines = [];
    for (int index = 0; index < widget.model.lines.length; index++) {
      lines.add(Row(
        children: [
          Checkbox(
            value: widget.model.lines[index].checked,
            onChanged: (bool? value) {
              setState(() {
                widget.model.lines[index].checked = value ?? false;
                widget.model.save();
              });
            },
          ),
          Expanded(
            child: TextFormField(
              controller: widget.model.lines[index].content,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                widget.model.lines.removeAt(index);
                widget.model.save();
              });
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ));
    }
    return lines;
  }
}

class CheckLine with ChangeNotifier {
  bool checked;
  TextEditingController content;

  CheckLine({
    required this.checked,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'checked': this.checked,
      'content': this.content.text,
    };
  }

  static CheckLine fromMap(Map<String, dynamic> map) {
    return CheckLine(
      checked: map['checked'] as bool,
      content: TextEditingController(text: map['content'] as String),
    );
  }

  void save() {
    notifyListeners();
  }
}

class CheckboxWidgetModel with ChangeNotifier {
  int position;
  List<CheckLine> lines = [];

  CheckboxWidgetModel({
    required this.lines,
    required this.position,
  });

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> content = [];
    lines.forEach((element) {
      content.add(element.toJson());
    });

    return {
      'name': 'CheckboxWidget',
      'lines': content,
      'position': this.position,
    };
  }

  static CheckboxWidgetModel fromMap(Map<String, dynamic> map) {
    List<CheckLine> content = [];
    for (var element in map['lines']) {
      content.add(CheckLine.fromMap(element));
    }

    return CheckboxWidgetModel(
      lines: content,
      position: map['position'] as int,
    );
  }

  void deleteLine(index) {
    lines.removeAt(index);
  }

  void save() {
    for (var element in lines) {
      element.save();
    }

    notifyListeners();
  }

  static CheckboxWidgetModel blank() {
    List<CheckLine> content = [];

    return CheckboxWidgetModel(lines: content, position: 1);
  }
}
