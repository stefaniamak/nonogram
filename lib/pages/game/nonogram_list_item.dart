import 'dart:math';

import 'package:flutter/material.dart';
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
  late Size? _puzzleSize = Size(50, 50); // const Size(0, 0);
  bool _isRendered = true;
  double? screenWidth;

  // @override
  // void initState() {
  //   SchedulerBinding.instance.addPostFrameCallback((_) {
  //     final RenderBox? renderBoxStickyBottom = _puzzleKey.currentContext?.findRenderObject() as RenderBox?;
  //     _puzzleSize = renderBoxStickyBottom?.size ?? const Size(0, 0);
  //     print('_puzzleSize: ${_puzzleSize}');
  //     _isRendered = true;
  //     screenWidth = MediaQuery.of(context).size.width;
  //     setState(() {});
  //   });
  //   super.initState();
  // }

  // void refresh() {
  //   setState(() => _isRendered = false);
  // }

  // static bool get isBuilding => [
  //       SchedulerPhase.transientCallbacks,
  //       SchedulerPhase.midFrameMicrotasks,
  //       SchedulerPhase.persistentCallbacks,
  //     ].contains(WidgetsBinding.instance.schedulerPhase);
  // ||  WidgetsBinding.instance.renderViewElement == null;

  // @override
  // void didUpdateWidget(covariant NonogramListItem oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //
  //   if (mounted) {
  //     //MediaQuery.of(context).size.width != oldWidget.createState().context.size?.width
  //     // if (mounted) {
  //     SchedulerBinding.instance.addPersistentFrameCallback((_) {
  //       final RenderBox? renderBoxStickyBottom = _puzzleKey.currentContext?.findRenderObject() as RenderBox?;
  //       _puzzleSize = renderBoxStickyBottom?.size ?? const Size(0, 0);
  //       setState(() {});
  //       // print('configuration changed');
  //     });
  //     // _isRendered = tru
  //     // }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double divider = MediaQuery.of(context).size.width < 1200 ? 1 : 3.8;
    final int columns = width > 1200 ? 3 : (width > 700 ? 2 : 1);
    final double cardWidth = (min(1200, width) * 0.65) / columns;

    _puzzleSize = Size(cardWidth, cardWidth);

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
                flex: 4,
                child: Builder(builder: (context) {
                  double width = MediaQuery.of(context).size.width;
                  // if (screenWidth != null && screenWidth != MediaQuery.of(context).size.width && mounted) {
                  //   SchedulerBinding.instance.addPostFrameCallback((_) {
                  //     final RenderBox? renderBoxStickyBottom = _puzzleKey.currentContext?.findRenderObject() as RenderBox?;
                  //     _puzzleSize = renderBoxStickyBottom?.size ?? const Size(0, 0);
                  //     // print('_puzzleSize: ${_puzzleSize}');
                  //     screenWidth = MediaQuery.of(context).size.width;
                  //   });
                  //   _isRendered = true;
                  //   setState(() {});
                  // }

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
              flex: 3,
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
