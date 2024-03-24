import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/game_loop/nonogram_list_state.dart';
import 'package:nonogram/pages/game/nonogram_list_item.dart';

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
                return NonogramListItem(nonogram: nonogram);
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
