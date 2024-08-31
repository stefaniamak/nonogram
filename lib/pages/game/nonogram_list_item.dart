import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';
import 'package:nonogram/pages/game/nonogram_page.dart';
import 'package:nonogram/pages/game/widgets/nonogram_title.dart';

class NonogramListItem extends StatelessWidget {
  const NonogramListItem({
    super.key,
    required this.nonogram,
  });

  final Nonogram nonogram;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final int columns = width > 1200 ? 3 : (width > 700 ? 2 : 1);
    final double cardWidth = (min(1200, width) * 0.65) / columns;
    final Size puzzleSize = Size(cardWidth, cardWidth);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => NonogramPage(nonogram: nonogram),
          ),
        );
      },
      child: Container(
        // color: Colors.grey.withOpacity(0.5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: NonogramGridAndClues(
                clues: nonogram.clues!,
                maxSize: puzzleSize,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NonogramTitle(nonogram: nonogram),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (nonogram.note != null)
                          ...nonogram.note!.split(',').map(
                                (e) => Chip(
                                  label: Text(e),
                                  labelStyle: const TextStyle(color: Colors.white),
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  // color: MaterialStateProperty.all(Colors.black.withOpacity(0.8)),
                                  backgroundColor: Colors.black.withOpacity(0.8),
                                  side: BorderSide(color: Colors.black.withOpacity(0.8)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
