import 'dart:math';

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
    final double width = (min(1200, MediaQuery.of(context).size.width) - 48) / 3.8;
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
            // if (false)
            Expanded(
              flex: 3,
              child: NonogramGridAndClues(
                // nonogram: nonogram,
                clues: nonogram.clues!,
                maxSize: Size(width, width),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                nonogram.info?.title ?? '-',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '(${nonogram.width}x${nonogram.height})',
                              style: const TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          nonogram.info?.description ?? '-',
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (nonogram.note != null) ...nonogram.note!.split(',').map((e) => Chip(label: Text(e))),
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
