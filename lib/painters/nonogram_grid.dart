import 'package:flutter/material.dart';
import 'package:nonogram/painters/grid_painter.dart';

/// A stateful widget that represents a Nonogram grid.
///
/// The `NonogramGrid` widget includes various parameters to configure the grid,
/// such as the size of each grid item, the overall size of the grid, the solution,
/// and callback functions for tap and pan events.
class NonogramGrid extends StatefulWidget {
  /// Creates a Nonogram Grid based on screen size.
  ///
  /// The [gridItemSide], [size], and [boxItems] parameters are required for the visual
  /// part of the grid and must not be null.
  ///
  /// The [solution], [onTap], [onPan], [onPanEnd], and [highlightedBoxes] parameters declare
  /// the functionality of the grid items, and are optional for the just view state.
  const NonogramGrid({
    required this.gridItemSide,
    required this.size,
    required this.boxItems,
    this.solution,
    this.onTap,
    this.onPan,
    this.onPanEnd,
    this.highlightedBoxes = const <int>[],
    super.key,
  });

  /// The size of each grid item.
  final double gridItemSide;

  /// The overall size of the grid.
  final Size size;

  /// The total number of columns (x line) and rows (y line) in the grid at a `Size(x,y)` format.
  final Size boxItems;

  /// The solution for the Nonogram puzzle.
  final String? solution;

  /// Callback function to be called when a grid item is tapped.
  final Function(int)? onTap;

  /// Callback function to be called when a grid item is panned.
  final Function(int)? onPan;

  /// Callback function to be called when a pan gesture ends.
  final Function(int)? onPanEnd;

  /// List of indices of highlighted boxes in the grid.
  final List<int> highlightedBoxes;

  @override
  State<NonogramGrid> createState() => _NonogramGridState();
}

/// The state for the `NonogramGrid` widget.
class _NonogramGridState extends State<NonogramGrid> {
  /// Indicates whether the tap gesture was canceled.
  bool _canceledOnTap = false;

  /// Gets the index of the grid item at the given position.
  ///
  /// The [position] parameter must not be null.
  int getIndex(Offset position) {
    return (position.dx / widget.gridItemSide).floor() +
        (position.dy / widget.gridItemSide).floor() * widget.boxItems.width.floor();
  }

  /// Handles the tap gesture at the given position.
  ///
  /// The [position] parameter must not be null.
  void _handleTap(Offset position) {
    widget.onTap?.call(getIndex(position));
    setState(() => _canceledOnTap = false);
  }

  /// Handles the pan gesture at the given position.
  ///
  /// The [position] parameter must not be null.
  void _handlePan(Offset position) {
    widget.onPan?.call(getIndex(position));
    if (_canceledOnTap) _canceledOnTap = false;
  }

  /// Handles the end of the pan gesture at the given position.
  ///
  /// The [position] parameter must not be null.
  void _handlePanEnd(Offset position) {
    widget.onPanEnd?.call(getIndex(position));
    setState(() => _canceledOnTap = false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: GestureDetector(
        onTapDown: (TapDownDetails details) => _handleTap(details.localPosition),
        onTapCancel: () => setState(() => _canceledOnTap = true),
        onVerticalDragStart: !_canceledOnTap ? (DragStartDetails details) => _handleTap(details.localPosition) : null,
        onVerticalDragUpdate: (DragUpdateDetails details) => _handlePan(details.localPosition),
        onVerticalDragEnd: (DragEndDetails details) => _handlePanEnd(details.localPosition),
        onPanStart: (!_canceledOnTap) ? (DragStartDetails details) => _handleTap(details.localPosition) : null,
        onPanUpdate: (DragUpdateDetails details) => _handlePan(details.localPosition),
        onPanEnd: (DragEndDetails details) => _handlePanEnd(details.localPosition),
        child: CustomPaint(
          isComplex: true,
          painter: GridPainter(
            boxItems: widget.boxItems,
            side: widget.gridItemSide,
            highlightedBoxes: widget.highlightedBoxes,
            solution: widget.solution,
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }
}
