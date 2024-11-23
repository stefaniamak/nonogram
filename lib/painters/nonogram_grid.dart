import 'package:flutter/material.dart';
import 'package:nonogram/painters/grid_painter.dart';

class NonogramGrid extends StatefulWidget {
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
  final double gridItemSide;
  final Size size;
  final Size boxItems;
  final String? solution;
  final Function(int)? onTap;
  final Function(int)? onPan;
  final Function(int)? onPanEnd;
  final List<int> highlightedBoxes;

  @override
  State<NonogramGrid> createState() => _NonogramGridState();
}

class _NonogramGridState extends State<NonogramGrid> {
  bool _canceledOnTap = false;

  int getIndex(Offset position) {
    return (position.dx / widget.gridItemSide).floor() +
        (position.dy / widget.gridItemSide).floor() * widget.boxItems.width.floor();
  }

  void _handleTap(Offset position) {
    widget.onTap?.call(getIndex(position));
    setState(() => _canceledOnTap = false);
  }

  void _handlePan(Offset position) {
    widget.onPan?.call(getIndex(position));
    if (_canceledOnTap) _canceledOnTap = false;
  }

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
