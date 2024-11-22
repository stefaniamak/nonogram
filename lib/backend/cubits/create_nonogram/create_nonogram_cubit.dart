import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:nonogram/backend/cubits/create_nonogram/create_nonogram_state.dart';
import 'package:nonogram/backend/cubits/create_nonogram/editing_settings.dart';
import 'package:nonogram/backend/cubits/create_nonogram/selected_line.dart';
import 'package:nonogram/backend/type_extensions/nono_string_extension.dart';

class CreateNonogramCubit extends Cubit<CreateNonogramState> {
  CreateNonogramCubit() : super(CreateNonogramState());

  void updateWidth(int index) {
    if (index > state.width) {
      state.horizontalClues.addAll(List<List<int>>.generate(index - state.width, (_) => <int>[0]));
    } else {
      state.horizontalClues.removeRange(index, state.width);
    }
    emit(state.copyWith(width: index));

    if (state.solution.length < state.height * state.width) {
      final int missingBoxes = state.height * state.width - state.solution.length;
      final int difference = (missingBoxes / state.height).ceil();

      /// Adds as many missing boxes are needed at the end of the solution line.
      /// That happens by finding the number of boxes that should be added at the end of each line [missingBoxes] and
      /// replacing every match with the same match plus the missing boxes.
      emit(state.copyWith(
          solution: state.solution.replaceAllMapped(RegExp(r'.{' + (index - difference).toString() + r'}'),
              (Match match) => "${match.group(0)}${Iterable.generate((missingBoxes / state.height).ceil(), (_) => '?').join()}",),),);
    } else if (state.solution.length > state.height * state.width) {
      final int extraBoxes = state.solution.length - state.height * state.width;
      final int difference = (extraBoxes / state.height).ceil();

      final String oldSolution = state.solution;
      final String newSolution = oldSolution.replaceAllMapped(
          RegExp(r'(.{' + (index).toString() + r'})(.{' + (difference).toString() + r'})'), (Match match) => "${match.group(1)}",);

      /// Removes as many extra boxes are needed at the end of the solution line.
      /// That happens by finding the number of boxes that should be removed at the end of each line [extraBoxes] and
      /// replacing every match with the same match [match.group(1)] without the extra boxes [match.group(2)].
      emit(state.copyWith(solution: newSolution));
      if (newSolution.sumFilledBoxes < oldSolution.sumFilledBoxes) updateVerticalClues();
    }
  }

  void updateHeight(int index) {
    if (index > state.height) {
      state.verticalClues.addAll(List<List<int>>.generate(index - state.height, (_) => <int>[0]));
    } else {
      state.verticalClues.removeRange(index, state.height);
    }
    emit(state.copyWith(height: index));

    if (state.solution.length < state.height * state.width) {
      emit(state.copyWith(
          solution: state.solution + Iterable.generate(state.height * state.width - state.solution.length, (_) => '?').join(),),);
    } else {
      final String oldSolution = state.solution;
      final String newSolution = oldSolution.substring(0, state.height * state.width);

      emit(state.copyWith(solution: newSolution));
      if (newSolution.sumFilledBoxes < oldSolution.sumFilledBoxes) updateHorizontalClues();
    }
  }

  void updateVerticalClues() {
    final RegExp regExp = RegExp(r'1+'); // Match one or more consecutive ones
    final List<List<int>> newVerticalClues = state.verticalClues;

    for (int row = 0; row < state.height; row++) {
      final Iterable<RegExpMatch> rowMatches = regExp.allMatches(state.solution.getRowIsolate(row, state.width));
      final List<int> rowClues = rowMatches.map((RegExpMatch match) => match.group(0)!.length).toList();
      newVerticalClues[row] = rowClues.isNotEmpty ? rowClues : <int>[0];
    }

    emit(state.copyWith(
      verticalClues: newVerticalClues,
    ),);
  }

  void updateHorizontalClues() {
    final RegExp regExp = RegExp(r'1+'); // Match one or more consecutive ones
    final List<List<int>> newHorizontalClues = state.horizontalClues;

    for (int column = 0; column < state.width; column++) {
      final Iterable<RegExpMatch> columnMatches = regExp.allMatches(state.solution.getColumnIsolate(column, state.width));
      final List<int> columnClues = columnMatches.map((RegExpMatch match) => match.group(0)!.length).toList();
      newHorizontalClues[column] = columnClues.isNotEmpty ? columnClues : <int>[0];
    }

    emit(state.copyWith(
      horizontalClues: newHorizontalClues,
    ),);
  }

  void updateBox(int boxIndex, [bool autoUpdateClues = true]) {
    // if (!_shouldUpdateBox(boxIndex)) {
    //   return;
    // }

    final bool isEmpty = state.solution.characterAt(boxIndex) == '?';
    emit(state.copyWith(solution: state.solution.replaceRange(boxIndex, boxIndex + 1, isEmpty ? '1' : '?')));

    if (autoUpdateClues) {
      updateClues(boxIndex, isEmpty);
    }
  }

  void updateClues(int boxIndex, bool isEmpty) {
    final int row = boxIndex ~/ state.width;
    final int column = boxIndex % state.width;

    print('boxIndex: $boxIndex, row: $row, column: $column');

    final RegExp regExp = RegExp(r'1+'); // Match one or more consecutive ones

    final Iterable<RegExpMatch> rowMatches = regExp.allMatches(state.solution.getRowIsolate(row, state.width));
    final List<int> rowClues = rowMatches.map((RegExpMatch match) => match.group(0)!.length).toList();

    final Iterable<RegExpMatch> columnMmatches = regExp.allMatches(state.solution.getColumnIsolate(column, state.width));
    final List<int> columnClues = columnMmatches.map((RegExpMatch match) => match.group(0)!.length).toList();

    final List<List<int>> newVerticalClues = state.verticalClues;
    newVerticalClues[row] = rowClues.isNotEmpty ? rowClues : <int>[0];

    final List<List<int>> newHorizontalClues = state.horizontalClues;
    newHorizontalClues[column] = columnClues.isNotEmpty ? columnClues : <int>[0];

    emit(state.copyWith(
      verticalClues: newVerticalClues,
      horizontalClues: newHorizontalClues,
      editingSettings: (isEmpty ? EditingSettings.paintMode : EditingSettings.eraseMode).copyWith(
        updateOnPanEnd: state.editingSettings.updateOnPanEnd,
      ),
    ),);
  }

  bool _shouldUpdateBox(int boxIndex) {
    if (state.editingSettings == EditingSettings.noMode) {
      return true;
    } else if (state.editingSettings.paint) {
      return state.solution.characterAt(boxIndex) == '?';
    } else if (state.editingSettings.erase) {
      return state.solution.characterAt(boxIndex) == '1';
    }
    return true;
  }

  void onPan(
    int boxIndex,
  ) {
    if (boxIndex > -1 && boxIndex < state.solution.length) {
      if (state.solution.characterAt(boxIndex) == '?' && state.editingSettings.paint) {
        updateBox(boxIndex, !state.editingSettings.updateOnPanEnd);
      } else if (state.solution.characterAt(boxIndex) == '1' && state.editingSettings.erase) {
        updateBox(boxIndex, !state.editingSettings.updateOnPanEnd);
      }
    }
  }

  void onPanEnd(int boxIndex) {
    final bool isEmpty = state.solution.characterAt(boxIndex) == '?';
    // updateClues(boxIndex, isEmpty);
    updateHorizontalClues();
    updateVerticalClues();
  }

  void setSelectedLine(Axis axis, int index, List<int> clues) {
    emit(state.copyWith(selectedLine: SelectedLine(axis: axis, index: index, clues: clues)));
  }

  void updateSelectedLine(String line) {
    final List<int> list = line.split(',').map((String e) => int.parse(e.trim())).toList();
    list.removeWhere((int e) => e == 0);
    if (list.isEmpty) list.add(0);

    List<List<int>> tempList;
    if (state.selectedLine!.axis == Axis.horizontal) {
      tempList = state.horizontalClues;
      tempList[state.selectedLine!.index] = list;
      emit(state.copyWith(horizontalClues: tempList));
    } else {
      tempList = state.verticalClues;
      tempList[state.selectedLine!.index] = list;
      emit(state.copyWith(verticalClues: tempList));
    }
  }

  void updateEditingSettingsOnPanEnd() {
    emit(state.copyWith(editingSettings: state.editingSettings.copyWith(updateOnPanEnd: !state.editingSettings.updateOnPanEnd)));
  }

  // void togglePaintMode() {
  //   emit(state.copyWith(editingSettings: state.editingSettings.paint ? EditingSettings.noMode : EditingSettings.paintMode));
  // }
  //
  // void toggleEraseMode() {
  //   emit(state.copyWith(editingSettings: state.editingSettings.erase ? EditingSettings.noMode : EditingSettings.eraseMode));
  // }
}
