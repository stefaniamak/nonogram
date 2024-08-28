import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';
import 'package:nonogram/pages/game/nonogram_page.dart';

class NonogramListItem extends StatefulWidget {
  const NonogramListItem({
    super.key,
    required this.nonogram,
  });

  final Nonogram nonogram;

  @override
  State<NonogramListItem> createState() => _NonogramListItemState();
}

class _NonogramListItemState extends State<NonogramListItem> {
  final GlobalKey _puzzleKey = GlobalKey();
  late Size? _puzzleSize = const Size(0, 0);
  bool _isRendered = false;

  // @override
  // void initState() {
  //   SchedulerBinding.instance.addPostFrameCallback((_) {
  //     final RenderBox? renderBoxStickyBottom = _puzzleKey.currentContext?.findRenderObject() as RenderBox?;
  //     _puzzleSize = renderBoxStickyBottom?.size ?? const Size(0, 0);
  //     print('_puzzleSize: ${_puzzleSize}');
  //     setState(() {});
  //   });
  //   super.initState();
  // }

  void refresh() {
    setState(() => _isRendered = false);
  }

  @override
  Widget build(BuildContext context) {
    final double divider = MediaQuery.of(context).size.width < 1200 ? 1 : 3.8;
    final double width = (min(1200, MediaQuery.of(context).size.width) - 48) / divider;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => NonogramPage(nonogram: widget.nonogram),
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
                key: _puzzleKey,
                flex: 3,
                child: Builder(builder: (context) {
                  if (!_isRendered) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      final RenderBox? renderBoxStickyBottom = _puzzleKey.currentContext?.findRenderObject() as RenderBox?;
                      _puzzleSize = renderBoxStickyBottom?.size ?? const Size(0, 0);
                      print('_puzzleSize: ${_puzzleSize}');
                      setState(() {});
                    });
                    _isRendered = true;
                  }

                  if (_puzzleSize != Size(0, 0)) {
                    return NonogramGridAndClues(
                      // nonogram: nonogram,
                      clues: widget.nonogram.clues!,
                      maxSize: _puzzleSize, //Size(width, width),
                    );
                  }

                  return const Row(
                    children: [
                      Expanded(child: SizedBox()),
                    ],
                  );
                })),
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
                                widget.nonogram.info?.title ?? '-',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '(${widget.nonogram.width}x${widget.nonogram.height})',
                              style: const TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.nonogram.info?.description ?? '-',
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (widget.nonogram.note != null)
                          ...widget.nonogram.note!.split(',').map(
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
