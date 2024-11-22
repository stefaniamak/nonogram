import 'package:flutter/material.dart';
import 'package:nonogram/backend/models/isolate/isolate_clues.dart';

class CluesUi extends StatelessWidget {

  const CluesUi({
    required this.clues, required this.boxSize, required this.axis, super.key,
    this.onEdit,
  });
  final IsolateClues clues;
  final double boxSize;
  final Axis axis;
  final Function(Axis axis, int index, List<int> clues)? onEdit;

  @override
  Widget build(BuildContext context) {
    final List<List<int>> list = axis == Axis.horizontal ? clues.columns : clues.rows;
    return Flexible(
      child: ListView.builder(
        scrollDirection: axis,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) {
          final List<int> c = list.elementAt(index);
          return InkWell(
            onTap: onEdit != null ? () => onEdit!.call(axis, index, c) : null,
            child: Flex(
              direction: axis == Axis.horizontal ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[...c.map((int i) => ClueBox(side: boxSize, numb: i))],
            ),
          );
        },
      ),
    );
  }
}

class ClueBox extends StatelessWidget {

  const ClueBox({required this.side, required this.numb, super.key});
  final double side;
  final int numb;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: side,
      height: side,
      child: FittedBox(
        child: Text(numb.toString()),
      ),
    );
  }
}
