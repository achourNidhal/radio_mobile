import 'package:flutter/cupertino.dart';
import 'package:radio_mobile/enums/radio-enum.dart';

class RadioStation {
  RadioEnum id;
  String label;
  String description;
  List<String> urls;
  String icon;
  bool selected = false;
  RadioStation(
      {@required this.id,
      @required this.label,
      @required this.urls,
      this.icon}) {
    this.urls = urls;
    this.icon = icon;
    this.selected = false;
  }
}
