import 'package:flutter/material.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';

class HomePage extends StatelessWidget {
  static const String route = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: const NonogramGridAndClues(),
      ),
    );
  }
}
