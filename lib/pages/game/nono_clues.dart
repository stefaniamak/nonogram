import 'package:flutter/material.dart';
import 'package:nonogram/backend/models/clues.dart';

class CluesUi extends StatelessWidget {
  final Clues clues;
  final double boxSize;
  final Axis axis;

  const CluesUi({
    super.key,
    required this.clues,
    required this.boxSize,
    required this.axis,
  });

  @override
  Widget build(BuildContext context) {
    if (axis == Axis.horizontal) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ...clues.columns.map(
            (c) => Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ...c.map(
                  (i) => ClueBox(side: boxSize, numb: i),
                )
              ],
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...clues.rows.map(
          (r) => Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...r.map(
                (i) => ClueBox(side: boxSize, numb: i),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ClueBox extends StatelessWidget {
  final double side;
  final int numb;

  const ClueBox({required this.side, required this.numb, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: side,
      height: side,
      padding: const EdgeInsets.all(4),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(numb.toString()),
      ),
    );
  }
}
