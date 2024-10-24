import 'package:flutter/material.dart';
import 'package:nonogram/backend/type_extensions/nono_string_extension.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/painters/grid_box.dart';

class NonogramGrid extends StatelessWidget {
  // final Nonogram nonogram;
  // final NonogramState? nonogramState;
  final double gridItemSide;

  final Size size;
  final Size boxItems;
  final String? solution;
  final Function(int)? onTap;
  final List<int> highlightedBoxes;

  const NonogramGrid({
    // required this.nonogram,
    // this.nonogramState,
    required this.gridItemSide,
    required this.size,
    required this.boxItems,
    this.solution,
    this.onTap,
    this.highlightedBoxes = const [],
    super.key,
  });

  PointState getGridBoxState(int index) {
    var char = solution?.characterAt(index);
    switch (char.toString()) {
      case '?':
        return PointState.unknown;
      case '1':
        return PointState.filled;
      case '0':
        return PointState.cross;
      default:
        return PointState.unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    // String? solution = nonogramState?.solutionSteps.elementAt(nonogramState!.stepNumber).currentSolution;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        // clipBehavior: Clip.none,
        // shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),

        itemCount: solution?.length ?? (boxItems.width * boxItems.height).ceil(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: boxItems.width.ceil(),
        ),
        itemBuilder: (BuildContext context, int index) {
          final CustomPaint customPaint = CustomPaint(
            isComplex: true,
            foregroundPainter: GridBox(
              pointState: getGridBoxState(index),
              side: gridItemSide,
              isHighlighted: highlightedBoxes.contains(index),
            ),
          );

          // return Text('X');
          // return DecoratedBox(
          //   decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          // );
          // switch (index.toString()) {
          //   case '?':
          //     return Icon(Icons.crop_square_sharp, size: gridItemSide);
          //     return DecoratedBox(
          //       decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          //     );
          //   case '1':
          //     return Icon(Icons.close);
          //   case '0':
          //     return SizedBox();
          //   default:
          //     return SizedBox();
          // }

          return onTap != null ? InkWell(onTap: () => onTap!.call(index), child: customPaint) : customPaint;
        },
      ),
    );
  }
}
