import 'package:flutter/material.dart';
import 'package:nonogram/backend/models/isolate/isolate_clues.dart';

class CluesUi extends StatelessWidget {
  final IsolateClues clues;
  final double boxSize;
  final Axis axis;
  final Function(Axis axis, int index, List<int> clues)? onEdit;

  const CluesUi({
    super.key,
    required this.clues,
    required this.boxSize,
    required this.axis,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final list = axis == Axis.horizontal ? clues.columns : clues.rows;
    return Flexible(
      child: ListView.builder(
        scrollDirection: axis,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) {
          List<int> c = list.elementAt(index);
          return InkWell(
            onTap: onEdit != null ? () => onEdit!.call(axis, index, c) : null,
            child: Flex(
              direction: axis == Axis.horizontal ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [...c.map((i) => ClueBox(side: boxSize, numb: i))],
            ),
          );
        },
      ),
    );
  }
}

class ClueBox extends StatelessWidget {
  final double side;
  final int numb;

  const ClueBox({required this.side, required this.numb, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: side,
      height: side,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(numb.toString()),
      ),
    );
  }
}
