import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/backend/cubits/nonogram_solver_cubit/nonogram_solver_cubit.dart';
import 'package:nonogram/backend/models/nonogram/nonogram.dart';
import 'package:nonogram/config/app_theme.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';
import 'package:nonogram/pages/game/nonogram_page.dart';
import 'package:nonogram/pages/game/widgets/nonogram_title.dart';

/// A stateless widget that represents a list item for a Nonogram.
class NonogramListItem extends StatelessWidget {
  /// Creates a NonogramListItem widget.
  ///
  /// The [nonogram] parameter is required and represents the Nonogram data.
  const NonogramListItem({
    required this.nonogram,
    super.key,
  });

  /// The Nonogram data to be displayed in the list item.
  final Nonogram nonogram;

  @override
  Widget build(BuildContext context) {
    // Get the width of the screen.
    final double width = MediaQuery.of(context).size.width;
    // Determine the number of columns based on the screen width.
    final int columns = AppTheme.maxPageColumns(context);
    // Calculate the width of each card based on the screen width and number of columns.
    final double cardWidth = (min(AppTheme.maxScreenConstraint, width) * 0.60) / columns;
    // Define the size of the puzzle inside the card.
    final Size puzzleSize = Size(cardWidth, cardWidth);

    return InkWell(
      // Navigate to the NonogramPage when the list item is tapped.
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => BlocProvider<NonogramSolverCubit>(
              create: (_) => NonogramSolverCubit()..initialize(nonogram: nonogram),
              child: NonogramPage(nonogram: nonogram),
            ),
          ),
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: IgnorePointer(
                child: NonogramGridAndClues(
                  clues: nonogram.clues,
                  maxSize: puzzleSize,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    NonogramTitle(nonogram: nonogram),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: <Widget>[
                        if (nonogram.note != null)
                          ...nonogram.note!.split(',').map(
                                (String e) => Chip(
                                  label: Text(e),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
