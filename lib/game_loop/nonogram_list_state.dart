import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';

import '../backend/database/nonograms.dart';

class NonogramListState {
  final List<IsolateNonogram> nonograms;

  const NonogramListState({required this.nonograms});
}

NonogramListState useNonogramList() {
  final ValueNotifier<List<IsolateNonogram>> nonograms$ = useState(
    Nonograms().allNonograms,
  );

  return NonogramListState(
    nonograms: nonograms$.value,
  );
}
