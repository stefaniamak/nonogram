import 'package:flutter/material.dart';
import 'package:nonogram/backend/models/nonogram/clues.dart';

/// A stateless widget that displays the UI for Nonogram clues.
class CluesUi extends StatelessWidget {
  /// Creates a CluesUi widget.
  ///
  /// The [clues] parameter is required and represents the Nonogram clues.
  /// The [boxSize] parameter is required and represents the size of each clue box.
  /// The [axis] parameter is required and represents the axis of the clues (horizontal or vertical).
  /// The [onEdit] parameter is optional and represents a callback function when a clue is edited.
  const CluesUi({
    required this.clues,
    required this.boxSize,
    required this.axis,
    this.onEdit,
    super.key,
  });

  /// The Nonogram clues to be displayed.
  final Clues clues;

  /// The size of each clue box.
  final double boxSize;

  /// The axis of the clues (horizontal or vertical).
  final Axis axis;

  /// A callback function when a clue is edited.
  final Function(Axis axis, int index, List<int> clues)? onEdit;

  @override
  Widget build(BuildContext context) {
    // Determine the list of clues based on the axis.
    final List<List<int>> list = axis == Axis.horizontal ? clues.columns : clues.rows;
    return Flexible(
      child: ListView.builder(
        scrollDirection: axis,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) {
          final List<int> clues = list[index];
          return InkWell(
            // Call the onEdit callback if it is not null.
            onTap: onEdit != null ? () => onEdit!.call(axis, index, clues) : null,
            child: Flex(
              direction: axis == Axis.horizontal ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.end,
              // Create a list of clue boxes based on the clues.
              children: clues.map((int clue) => _ClueBox(side: boxSize, clueValue: clue)).toList(),
            ),
          );
        },
      ),
    );
  }
}

/// A stateless widget that represents a single clue box.
class _ClueBox extends StatelessWidget {
  /// Creates a _ClueBox widget.
  ///
  /// The [side] parameter is required and represents the size of the box.
  /// The [clueValue] parameter is required and represents the value of the clue.
  const _ClueBox({required this.side, required this.clueValue});

  /// The size of the box.
  final double side;

  /// The value of the clue.
  final int clueValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: side,
      height: side,
      child: FittedBox(
        child: Text(clueValue.toString()),
      ),
    );
  }
}
