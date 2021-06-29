import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:desk/content/text.dart';
import 'package:desk/content/checkbox.dart';

class WidgetableContent {
  List _models = [];

  List get models => _models;

  void encode(String body) {
    final content = json.decode(body);
    _models.clear();
    _models.addAll(_jsonToContent(content));
  }

  void add(Widget modelItem) {
    models.add(modelItem);
  }

  void addBlankWidgetFromString(String name) {
    switch (name) {
      case 'TextWidget':
        models.add(TextWidget(model: TextWidgetModel.blank()));
        break;
      case 'CheckboxWidget':
        models.add(CheckboxWidget(model: CheckboxWidgetModel.blank()));
        break;
    }
  }

  List _jsonToContent(List content) {
    List models = [];
    for (var item in content) {
      switch (item['name']) {
        case 'TextWidget':
          models.add(TextWidget(model: TextWidgetModel.fromMap(item)));
          break;
        case 'CheckboxWidget':
          models.add(CheckboxWidget(model: CheckboxWidgetModel.fromMap(item)));
          break;
        default:
      }
    }

    return models;
  }

  String decode() {
    var body = [];
    for (var widget in _models) {
      body.add(widget.model.toJson());
    }

    return json.encode(body);
  }
}
