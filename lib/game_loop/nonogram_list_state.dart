import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/nonogram.dart';

import '../backend/database/nonograms.dart';

class NonogramListState {
  final List<Nonogram> nonograms;

  const NonogramListState({required this.nonograms});
}

NonogramListState useNonogramList() {
  final ValueNotifier<List<Nonogram>> nonograms$ = useState(
    Nonograms().allNonograms,
  );

  return NonogramListState(
    nonograms: nonograms$.value,
  );
}
