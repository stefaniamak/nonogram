import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/database/nonograms.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/painters/nonogram_grid.dart';

class NonogramGridAndClues extends HookWidget {
  const NonogramGridAndClues({super.key});

  @override
  Widget build(BuildContext context) {
    Nonogram draftNono = Nonograms().dancer;
    var nonogramState = useNonogramState(draftNono);

    // todo: na vrw auto me ta perissotera chars, oxi perissoterous arithmous apla
    final numbsWidth = draftNono.clues!.rows.map((r) => r.length).reduce(max);
    final numbsHeight =
        draftNono.clues!.columns.map((c) => c.length).reduce(max);

    print('numbsWidth: $numbsWidth');

    final nonoWidth = MediaQuery.of(context).size.width - 64;
    final nonoHeight =
        (MediaQuery.of(context).size.height * 0.8) - numbsHeight * 6;
    final gridWidth = nonoWidth - numbsWidth * 12;
    final gridItemWidth = gridWidth / nonogramState.nonogram.width;
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('test 1'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ...nonogramState.nonogram.clues!.rows.map(
                      (r) => SizedBox(
                        height: gridItemWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [...r.map((i) => Text('$i'))],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 2),
                // Text('test 2'),
                // error is here aaaa
                // SizedBox(
                //   height: nonoHeight,
                //   child: ListView.builder(
                //     itemCount: nonogramState.nonogram.clues!.rows.length,
                //     itemBuilder: (BuildContext context, int row) {
                //       return SizedBox(
                //         height: gridWidth / nonogramState.nonogram.width,
                //         child: ListView.builder(
                //           scrollDirection: Axis.horizontal,
                //           itemCount: nonogramState.nonogram.clues!.rows
                //               .elementAt(row)
                //               .length,
                //           itemBuilder: (BuildContext context, int item) {
                //             return SizedBox(
                //               width: 6,
                //               child: Text(
                //                 nonogramState.nonogram.clues!.rows
                //                     .elementAt(row)
                //                     .elementAt(item)
                //                     .toString(),
                //               ),
                //             );
                //           },
                //         ),
                //       );
                //     },
                //     // child: Row(
                //     //   children: nonogramState.nonogram.,
                //     // ),
                //   ),
                // ),
                NonogramGrid(
                  nonogramState: nonogramState,
                  // todo: find *number based on dekades as well
                  gridWidth: gridWidth,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
