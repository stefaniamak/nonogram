import 'package:flutter/material.dart';

extension NonoStringExtension on String {
  String characterAt(int index) => characters.elementAt(index);

  int get sumFilledBoxes =>
      split('').fold(0, (previousValue, element) => previousValue + (element != '?' ? int.parse(element) : 0));

  bool isSameClueIndexWith(String element) =>
      (this == element) && this != '?' && element != '0' && this != '?' && element != '0';
}
