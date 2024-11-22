import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/backend/cubits/create_nonogram/create_nonogram_cubit.dart';
import 'package:nonogram/backend/database/nonograms.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/pages/app_page.dart';
import 'package:nonogram/pages/game/create_nonogram_page.dart';
import 'package:nonogram/pages/game/nonogram_list_item.dart';
import 'package:nonogram/pages/widgets/blur_container.dart';

class NonogramListPage extends StatelessWidget {
  static const String route = '/puzzles';

  const NonogramListPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  builder: (BuildContext context) => BlocProvider(
                    create: (_) => CreateNonogramCubit(),
                    child: const CreateNonogramPage(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      children: [
        if (Nonograms.all.isNotEmpty)
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                IsolateNonogram nonogram = Nonograms.all[index];
                return NonogramListItem(nonogram: nonogram);
              },
              childCount: Nonograms.all.length,
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
