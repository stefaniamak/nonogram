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
  bool _calceledOnTap = false;

  int getIndex(Offset position) {
    return (position.dx / widget.gridItemSide).floor() +
        (position.dy / widget.gridItemSide).floor() * widget.boxItems.width.floor();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: GestureDetector(
        // behavior: HitTestBehavior.deferToChild,
        onTapDown: (TapDownDetails details) {
          widget.onTap?.call(getIndex(details.localPosition));
          setState(() {
            _calceledOnTap = false;
          });
        },
        onTapCancel: () {
          setState(() {
            _calceledOnTap = true;
          });
        },
        onVerticalDragStart: (DragStartDetails details) {
          if (!_calceledOnTap) widget.onTap?.call(getIndex(details.localPosition));
        },
        onVerticalDragUpdate: (DragUpdateDetails details) {
          widget.onPan?.call(getIndex(details.localPosition));
          if (_calceledOnTap) _calceledOnTap = false;
        },
        onVerticalDragEnd: (DragEndDetails details) {
          widget.onPanEnd?.call(getIndex(details.localPosition));
          setState(() {
            _calceledOnTap = false;
          });
        },
        onPanStart: (DragStartDetails details) {
          if (!_calceledOnTap) widget.onTap?.call(getIndex(details.localPosition));
        },
        onPanUpdate: (DragUpdateDetails details) {
          widget.onPan?.call(getIndex(details.localPosition));
          if (_calceledOnTap) _calceledOnTap = false;
        },
        onPanEnd: (DragEndDetails details) {
          widget.onPanEnd?.call(getIndex(details.localPosition));
          setState(() {
            _calceledOnTap = false;
          });
        },
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
