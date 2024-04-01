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
      floatingActionButton: Ink(
        width: 56,
        height: 56,
        decoration: const ShapeDecoration(
          color: Colors.yellowAccent,
          shape: CircleBorder(),
        ),
        child: IconButton(
          icon: const Icon(Icons.add),
          color: Colors.black,
          onPressed: () {},
        ),
      ),
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
            ),
          ),
      ]),
      // body: NonogramPage(
      //   nonogram: Nonograms().dancer,
      // ),
    );
  }
}
