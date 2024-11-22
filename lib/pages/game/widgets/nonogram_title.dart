import 'package:flutter/material.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';

class NonogramTitle extends StatelessWidget {
  const NonogramTitle({
    required this.nonogram, super.key,
    this.showDescription = true,
  });

  final IsolateNonogram nonogram;
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
