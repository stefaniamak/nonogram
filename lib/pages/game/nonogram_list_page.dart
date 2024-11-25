import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/backend/cubits/create_nonogram/create_nonogram_cubit.dart';
import 'package:nonogram/backend/database/nonograms.dart';
import 'package:nonogram/config/app_theme.dart';
import 'package:nonogram/pages/app_page.dart';
import 'package:nonogram/pages/game/create_nonogram_page.dart';
import 'package:nonogram/pages/game/nonogram_list_item.dart';
import 'package:nonogram/pages/widgets/buttons/app_fab.dart';

/// The screen where you can view a list of nonogram puzzles.
class NonogramListPage extends StatelessWidget {
  /// Creates a NonogramListPage widget.
  const NonogramListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      floatingActionButton: AppFab(
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => BlocProvider<CreateNonogramCubit>(
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
              /// Builds a NonogramListItem for each nonogram in the list.
              (BuildContext context, int index) => NonogramListItem(nonogram: Nonograms.all[index]),
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
