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
				onChanged: (v) {
					widget.model.content = v;
					widget.model.save();
				},
				initialValue: widget.model.content,
			),
		);
	}
}


class TextWidgetModel with ChangeNotifier {
	int position;
	String content;

	TextWidgetModel({
		required this.content,
		required this.position,
	});

	Map<String, dynamic> toJson() {
		return {
			'name': 'TextWidget',
			'content': this.content,
			'position': this.position,
		};
	}

	static TextWidgetModel fromMap(Map<String, dynamic> map) {
		return TextWidgetModel(
			position: map['position'] as int,
			content: map['content'] as String,
		);
	}

	void save() {
    	notifyListeners();
    }
}