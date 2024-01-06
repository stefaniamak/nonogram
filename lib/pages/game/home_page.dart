import 'package:flutter/material.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';

class HomePage extends StatelessWidget {
  static const String route = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NonogramGridAndClues();
  }
}
