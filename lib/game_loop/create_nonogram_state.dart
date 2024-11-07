import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/isolate/isolate_clues.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/backend/type_extensions/nono_string_extension.dart';

import 'nonogram_state.dart';

@Deprecated('Use CreateNonogramState from create_nonogram file instead')
class CreateNonogramState {
  final IsolateNonogram nonogram;
  final int width;
  final int height;
  final List<List<int>> horizontalClues;
  final List<List<int>> verticalClues;
  final Function(int width) updateWidth;
  final Function(int height) updateHeight;
  final Function(int index, PointState pointState) updateSolution;
  final Function(Axis axis, int index, List<int> clues) setSelectedLine;
  final Function(String line) updateSelectedLine;
  final TextEditingController selectedLineTextEditingController;
  // final Function(Clues clues) updateClues;
  final String solution;
  final Function(int boxIndex) updateBox;

  @Deprecated('Use CreateNonogramState from create_nonogram file instead')
  CreateNonogramState({
    required this.nonogram,
    required this.width,
    required this.height,
    required this.horizontalClues,
    required this.verticalClues,
    required this.updateWidth,
    required this.updateHeight,
    required this.updateSolution,
    // required this.updateClues,
    required this.solution,
    required this.setSelectedLine,
    required this.updateSelectedLine,
    required this.selectedLineTextEditingController,
    required this.updateBox,
  });
}

@Deprecated('Use CreateNonogramState from create_nonogram file instead')
CreateNonogramState useCreateNonogramState() {
  // Initializations

  final width$ = useState(5);
  final height$ = useState(5);
  final verticalClues$ = useState([
    ...List<List<int>>.generate(height$.value, (_) => <int>[0]),
  ]);
  final horizontalClues$ = useState([
    ...List<List<int>>.generate(width$.value, (_) => <int>[0]),
  ]);
  final solution$ = useState(
    Iterable.generate(width$.value * height$.value, (_) => '?').join(),
  );
  final nonogram$ = useState(
    IsolateNonogram(
        id: 'test',
        // ..info = NonogramInfo((i) => i
        //   ..title = "Dancer"
        //   ..copyright = "(c) Copyright 2004 by Jan Wolter"
        //   ..author = "Jan Wolter"
        //   ..authorId = "jan"
        //   ..description = "A stick figure man, dancing his stickly little heart out.").toBuilder()
        // ..note = "published,definitely unique,definitely line/color solvable"
        clues: IsolateClues(
          columns: verticalClues$.value,
          rows: horizontalClues$.value,
        )),
  );

  final selectedLineAxis$ = useState(Axis.horizontal);
  final selectedLineIndex$ = useState(-1);
  final selectedLineClues$ = useState(<int>[0]);
  final selectedLineTextEditingController = useTextEditingController();

  // Functions

  final updateWidth = useCallback((int index) {
    if (index > width$.value) {
      horizontalClues$.value.addAll(List<List<int>>.generate(index - width$.value, (_) => <int>[0]));
    } else {
      horizontalClues$.value.removeRange(index, width$.value);
    }
    width$.value = index;

    if (solution$.value.length < height$.value * width$.value) {
      int missingBoxes = height$.value * width$.value - solution$.value.length;
      int difference = (missingBoxes / height$.value).ceil();

      /// Adds as many missing boxes are needed at the end of the solution line.
      /// That happens by finding the number of boxes that should be added at the end of each line [missingBoxes] and
      /// replacing every match with the same match plus the missing boxes.
      solution$.value = solution$.value.replaceAllMapped(RegExp(r'.{' + (index - difference).toString() + r'}'),
          (match) => "${match.group(0)}${Iterable.generate((missingBoxes / height$.value).ceil(), (_) => '?').join()}");
    } else if (solution$.value.length > height$.value * width$.value) {
      int extraBoxes = solution$.value.length - height$.value * width$.value;
      int difference = (extraBoxes / height$.value).ceil();

      /// Removes as many extra boxes are needed at the end of the solution line.
      /// That happens by finding the number of boxes that should be removed at the end of each line [extraBoxes] and
      /// replacing every match with the same match [match.group(1)] without the extra boxes [match.group(2)].
      solution$.value = solution$.value.replaceAllMapped(
          RegExp(r'(.{' + (index).toString() + r'})(.{' + (difference).toString() + r'})'), (match) => "${match.group(1)}");
    }
  });

  final updateHeight = useCallback((int index) {
    if (index > height$.value) {
      verticalClues$.value.addAll(List<List<int>>.generate(index - height$.value, (_) => <int>[0]));
    } else {
      verticalClues$.value.removeRange(index, height$.value);
    }
    height$.value = index;

    if (solution$.value.length < height$.value * width$.value) {
      solution$.value =
          solution$.value + Iterable.generate(height$.value * width$.value - solution$.value.length, (_) => '?').join();
    } else {
      solution$.value = solution$.value.substring(0, height$.value * width$.value);
    }
  });

  final updateSolution = useCallback((int index, PointState pointState) {
    height$.value = index;
  });

  final updateNonogram = useCallback(() {
    nonogram$.value = IsolateNonogram(
        id: 'test',
        // ..info = NonogramInfo((i) => i
        //   ..title = "Dancer"
        //   ..copyright = "(c) Copyright 2004 by Jan Wolter"
        //   ..author = "Jan Wolter"
        //   ..authorId = "jan"
        //   ..description = "A stick figure man, dancing his stickly little heart out.").toBuilder()
        // ..note = "published,definitely unique,definitely line/color solvable"
        clues: IsolateClues(
          columns: verticalClues$.value,
          rows: horizontalClues$.value,
        ));

    //     .rebuild(
    //   (p0) => p0
    //     ..id = "test"
    //     // ..info = NonogramInfo((i) => i
    //     //   ..title = "Dancer"
    //     //   ..copyright = "(c) Copyright 2004 by Jan Wolter"
    //     //   ..author = "Jan Wolter"
    //     //   ..authorId = "jan"
    //     //   ..description = "A stick figure man, dancing his stickly little heart out.").toBuilder()
    //     // ..note = "published,definitely unique,definitely line/color solvable"
    //     ..clues = Clues(
    //       (c) => c
    //         ..columns = ListBuilder(verticalClues$.value)
    //         ..rows = ListBuilder(horizontalClues$.value),
    //     ).toBuilder(),
    // );
  }, [width$.value, height$.value, verticalClues$.value, horizontalClues$.value]);

  // final updateClues = useCallback((NonoAxis axis, int index, List<>) {
  //   height$.value = index;
  // });

  final setSelectedLine = useCallback((Axis axis, int index, List<int> clues) {
    selectedLineAxis$.value = axis;
    selectedLineIndex$.value = index;
    selectedLineClues$.value = clues;
    selectedLineTextEditingController.text = clues.join(', ');
  });

  final updateSelectedLine = useCallback((String line) {
    List<int> list = line.split(',').map((e) => int.parse(e.trim())).toList();
    list.removeWhere((e) => e == 0);
    if (list.isEmpty) list.add(0);
    (selectedLineAxis$.value == Axis.horizontal ? horizontalClues$ : verticalClues$).value[selectedLineIndex$.value] = list;
  });

  final updateBox = useCallback((int boxIndex) {
    final bool isEmpty = solution$.value.characterAt(boxIndex) == '?';
    solution$.value = solution$.value.replaceRange(boxIndex, boxIndex + 1, isEmpty ? '1' : '?');

    int row = boxIndex ~/ width$.value;
    int column = boxIndex % width$.value;

    print('boxIndex: $boxIndex, row: $row, column: $column');

    RegExp regExp = RegExp(r'1+'); // Match one or more consecutive ones

    Iterable<RegExpMatch> rowMatches = regExp.allMatches(solution$.value.getRowIsolate(row, width$.value));
    List<int> rowClues = rowMatches.map((match) => match.group(0)!.length).toList();

    Iterable<RegExpMatch> columnMmatches = regExp.allMatches(solution$.value.getColumnIsolate(column, width$.value));
    List<int> columnClues = columnMmatches.map((match) => match.group(0)!.length).toList();

    verticalClues$.value[row] = rowClues.isNotEmpty ? rowClues : [0];
    horizontalClues$.value[column] = columnClues.isNotEmpty ? columnClues : [0];
  });

  return CreateNonogramState(
    nonogram: nonogram$.value,
    width: width$.value,
    height: height$.value,
    horizontalClues: horizontalClues$.value,
    verticalClues: verticalClues$.value,
    updateWidth: updateWidth,
    updateHeight: updateHeight,
    updateSolution: updateSolution,
    // updateClues: updateClues,
    solution: solution$.value,
    setSelectedLine: setSelectedLine,
    updateSelectedLine: updateSelectedLine,
    selectedLineTextEditingController: selectedLineTextEditingController,
    updateBox: updateBox,
  );
}
