import 'package:flutter/material.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';

class NonogramPage extends StatelessWidget {
  final Nonogram nonogram;

  const NonogramPage({
    required this.nonogram,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NonogramGridAndClues(
          nonogram: nonogram,
          padding: const EdgeInsets.all(32),
        ),
        InkWell(
          onTap: () {},
          child: const SizedBox(
            height: 50,
            width: 80,
            child: Center(child: Text('Solve')),
          ),
        )
      ],
    );
  }
}
