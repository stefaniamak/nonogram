import 'package:flutter/material.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';
import 'package:nonogram/pages/game/nonogram_page.dart';

class NonogramListItem extends StatelessWidget {
  const NonogramListItem({
    super.key,
    required this.nonogram,
  });

  final Nonogram nonogram;

  @override
  Widget build(BuildContext context) {
    final double width = (MediaQuery.of(context).size.width - 48) / 3.5;
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
        color: Colors.grey.withOpacity(0.5),
        child: Column(
          children: [
            NonogramGridAndClues(
              nonogram: nonogram,
              maxSize: Size(width, width),
            ),
            Text(nonogram.info?.title ?? '-'),
          ],
        ),
      ),
    );
  }
}
