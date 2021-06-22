import 'package:flutter/material.dart';


class TextWidget extends StatefulWidget {
	TextWidgetModel model;

	TextWidget({Key? key, required this.model}): super(key: key);

	@override
	_TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {

		@override
	Widget build(BuildContext context) {
		return Container(
			child: TextFormField(
				controller: widget.model.content,
			),
		);
	}
}


class TextWidgetModel with ChangeNotifier {
	int position;
	TextEditingController content;

	TextWidgetModel({
		required this.content,
		required this.position,
	});

	Map<String, dynamic> toJson() {
		return {
			'name': 'TextWidget',
			'position': this.position,
			'content': this.content.text,
		};
	}

	static TextWidgetModel fromMap(Map<String, dynamic> map) {
		return TextWidgetModel(
			position: map['position'] as int,
			content: TextEditingController(text: map['content'] as String),
		);
	}

	void save() {
    	notifyListeners();
    }
}