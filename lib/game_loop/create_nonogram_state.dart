import 'package:flutter/cupertino.dart';
import 'package:nonogram/backend/models/clues.dart';
import 'package:nonogram/backend/models/nonogram.dart';

class CreateNonogramState {
  final Nonogram nonogram;
  final Function(double width) updateWidth;
  final Function(double height) updateHeight;
  final Function(Clues clues) updateClues;

  CreateNonogramState({
    required this.nonogram,
    required this.updateWidth,
    required this.updateHeight,
    required this.updateClues,
  });
}
