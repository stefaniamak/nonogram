import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/backend/cubits/create_nonogram/create_nonogram_cubit.dart';
import 'package:nonogram/backend/database/nonograms.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/config/app_theme.dart';
import 'package:nonogram/pages/app_page.dart';
import 'package:nonogram/pages/game/create_nonogram_page.dart';
import 'package:nonogram/pages/game/nonogram_list_item.dart';

import '../widgets/buttons/app_fab.dart';

class NonogramListPage extends StatelessWidget {
  const NonogramListPage({super.key});
  static const String route = '/puzzles';

  @override
  Widget build(BuildContext context) {
    return AppPage(
      floatingActionButton: AppFab(
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => BlocProvider<CreateNonogramCubit>(
                create: (_) => CreateNonogramCubit(),
                child: const CreateNonogramPage(),
              ),
            ),
          );
        },
      ),
      children: <Widget>[
        if (Nonograms.all.isNotEmpty)
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final IsolateNonogram nonogram = Nonograms.all[index];
                return NonogramListItem(nonogram: nonogram);
              },
              childCount: Nonograms.all.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppTheme.maxPageColumns(context),
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: 4 / 5,
            ),
          ),
      ],
    );
  }
}
