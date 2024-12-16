import 'package:flutter/material.dart';
import 'package:nonogram/backend/models/nonogram/nonogram.dart';

/// A stateless widget that displays the title and description of a Nonogram.
class NonogramTitle extends StatelessWidget {
  /// Creates a NonogramTitle widget.
  ///
  /// The [nonogram] parameter is required and represents the Nonogram data.
  /// The [showDescription] parameter is optional and defaults to true. It determines whether the description should be shown.
  const NonogramTitle({
    required this.nonogram,
    this.showDescription = true,
    super.key,
  });

  /// The Nonogram data to be displayed.
  final Nonogram nonogram;

  /// Whether to show the description of the Nonogram.
  final bool showDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              child: Text(
                '${nonogram.info?.title ?? ' - '} #${nonogram.id}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${nonogram.width}x${nonogram.height})',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
        if (showDescription) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            nonogram.info?.description ?? '-',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ],
    );
  }
}
