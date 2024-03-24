import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/game_loop/nonogram_list_state.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';

class NonogramListPage extends HookWidget {
  static const String route = '/puzzles';

  const NonogramListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NonogramListState nonogramListState = useNonogramList();
    return Scaffold(
      body: CustomScrollView(slivers: [
        if (nonogramListState.nonograms.isNotEmpty)
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                Nonogram nonogram = nonogramListState.nonograms[index];
                return Container(
                  color: Colors.grey,
                  child: Column(
                    children: [
                      NonogramGridAndClues(
                        nonogram: nonogram,
                        maxSize: const Size(250, 250),
                      ),
                      Text(nonogram.info?.title ?? '-'),
                    ],
                  ),
                );
              },
              childCount: nonogramListState.nonograms.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          ),
      ]),
      // body: NonogramPage(
      //   nonogram: Nonograms().dancer,
      // ),
    );
  }
}
