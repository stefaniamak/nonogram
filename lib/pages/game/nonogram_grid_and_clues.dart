import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/pages/game/nono_clues.dart';
import 'package:nonogram/pages/game/nonogram_ui.dart';
import 'package:nonogram/painters/nonogram_grid.dart';

class NonogramGridAndClues extends HookWidget {
  final Nonogram nonogram;
  final EdgeInsets padding;
  final Size? maxSize;

  const NonogramGridAndClues({
    required this.nonogram,
    this.padding = EdgeInsets.zero,
    this.maxSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var md = MediaQuery.of(context);
    var maxSize = this.maxSize ?? md.size;

    var nonogramState = useNonogramState(nonogram);
    var nonogramUi = useNonogramUi(nonogram, maxSize, padding);

    return Container(
      width: nonogramUi.size.width,
      height: nonogramUi.size.height,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ...nonogramState.nonogram.clues!.columns.map(
                (c) => Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ...c.map(
                      (i) => ClueBox(side: nonogramUi.gridItemSide, numb: i),
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ...nonogramState.nonogram.clues!.rows.map(
                    (r) => Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ...r.map(
                          (i) =>
                              ClueBox(side: nonogramUi.gridItemSide, numb: i),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              NonogramGrid(
                nonogramState: nonogramState,
                nonogramUi: nonogramUi,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
