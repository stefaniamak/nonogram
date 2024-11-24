import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/backend/cubits/nonogram_solver_cubit/nonogram_solver_cubit.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';
import 'package:nonogram/pages/game/nonogram_page.dart';
import 'package:nonogram/pages/game/widgets/nonogram_title.dart';

class NonogramListItem extends StatelessWidget {
  const NonogramListItem({
    required this.nonogram,
    super.key,
  });

  final IsolateNonogram nonogram;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final int columns = width > 1200 ? 3 : (width > 700 ? 2 : 1);
    final double cardWidth = (min(1200, width) * 0.60) / columns;
    final Size puzzleSize = Size(cardWidth, cardWidth);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => BlocProvider(
              create: (_) => NonogramSolverCubit()..initialize(nonogram: nonogram),
              child: NonogramPage(nonogram: nonogram),
            ),
          ),
        );
      },
      child: DecoratedBox(
        // color: Colors.grey.withOpacity(0.5),
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
