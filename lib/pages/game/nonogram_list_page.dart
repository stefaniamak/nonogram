import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/game_loop/nonogram_list_state.dart';
import 'package:nonogram/pages/app_page.dart';
import 'package:nonogram/pages/game/create_nonogram_page.dart';
import 'package:nonogram/pages/game/nonogram_list_item.dart';
import 'package:nonogram/pages/widgets/blur_container.dart';

class NonogramListPage extends HookWidget {
  static const String route = '/puzzles';

  const NonogramListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NonogramListState nonogramListState = useNonogramList();
    double width = MediaQuery.of(context).size.width;
    return AppPage(
      floatingActionButton: BlurContainer(
        color: Colors.yellowAccent,
        borderRadius: 32,
        child: Ink(
          width: 56,
          height: 56,
          decoration: const ShapeDecoration(
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: const Icon(Icons.add),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const CreateNonogramPage(),
                ),
              );
            },
          ),
        ),
      ),
      children: [
        if (nonogramListState.nonograms.isNotEmpty)
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                IsolateNonogram nonogram = nonogramListState.nonograms[index];
                return NonogramListItem(nonogram: nonogram);
              },
              childCount: nonogramListState.nonograms.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: width > 1200 ? 3 : (width > 700 ? 2 : 1),
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: 4 / 5,
            ),
          ),
      ],
    );
  }
}

class BottomNavigationPadding extends StatelessWidget {
  const BottomNavigationPadding({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).padding.bottom);
  }
}
