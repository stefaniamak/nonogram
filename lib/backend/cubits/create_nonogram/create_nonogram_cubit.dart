import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:nonogram/backend/cubits/create_nonogram/create_nonogram_state.dart';
import 'package:nonogram/backend/cubits/create_nonogram/editing_settings.dart';
import 'package:nonogram/backend/cubits/create_nonogram/selected_line.dart';
import 'package:nonogram/backend/type_extensions/nono_string_extension.dart';

/// A Cubit class to manage the state of creating a Nonogram.
class CreateNonogramCubit extends Cubit<CreateNonogramState> {
  /// Constructor to initialize the CreateNonogramCubit with an initial state.
  CreateNonogramCubit() : super(CreateNonogramState());

  /// Updates the width of the Nonogram grid.
  ///
  /// This function adjusts the width of the Nonogram grid and updates the horizontal clues and solution accordingly.
  /// It handles adding or removing clues and adjusting the solution string to match the new width.
  ///
  /// Parameters:
  /// - [index]: The new width of the grid.
  void updateWidth(int index) {
    if (index > state.width) {
      state.horizontalClues.addAll(List<List<int>>.generate(index - state.width, (_) => <int>[0]));
    } else {
      state.horizontalClues.removeRange(index, state.width);
    }
    emit(state.copyWith(width: index));

    final int totalBoxes = state.height * state.width;
    final int missingBoxes = totalBoxes - state.solution.length;
    final int difference = (missingBoxes / state.height).ceil();

    if (missingBoxes > 0) {
      /// Adds as many missing boxes are needed at the end of the solution line.
      /// That happens by finding the number of boxes that should be added at the end of each line [missingBoxes] and
      /// replacing every match with the same match plus the missing boxes.
      emit(
        state.copyWith(
          solution: state.solution.replaceAllMapped(
            RegExp(r'.{' + (index - difference).toString() + r'}'),
            (Match match) => "${match.group(0)}${'?' * difference}",
          ),
        ),
      );
    } else {
      final String oldSolution = state.solution;
      final int extraBoxes = oldSolution.length - totalBoxes;
      final String newSolution = oldSolution.replaceAllMapped(
        RegExp(r'(.{' + index.toString() + r'})(.{' + (extraBoxes / state.height).ceil().toString() + r'})'),
        (Match match) => match.group(1)!,
      );

      /// Removes as many extra boxes are needed at the end of the solution line.
      /// That happens by finding the number of boxes that should be removed at the end of each line [extraBoxes] and
      /// replacing every match with the same match [match.group(1)] without the extra boxes [match.group(2)].
      emit(state.copyWith(solution: newSolution));
      if (newSolution.sumFilledBoxes < oldSolution.sumFilledBoxes) updateVerticalClues();
    }
  }

  /// Updates the height of the Nonogram grid.
  ///
  /// This function adjusts the height of the Nonogram grid and updates the vertical clues and solution accordingly.
  /// It handles adding or removing clues and adjusting the solution string to match the new height.
  ///
  /// Parameters:
  /// - [index]: The new height of the grid.
  void updateHeight(int index) {
    if (index > state.height) {
      state.verticalClues.addAll(List<List<int>>.generate(index - state.height, (_) => <int>[0]));
    } else {
      state.verticalClues.removeRange(index, state.height);
    }
    emit(state.copyWith(height: index));

    final int totalBoxes = state.height * state.width;
    if (state.solution.length < totalBoxes) {
      emit(state.copyWith(solution: state.solution + '?' * (totalBoxes - state.solution.length)));
    } else {
      final String oldSolution = state.solution;
      final String newSolution = oldSolution.substring(0, totalBoxes);
      emit(state.copyWith(solution: newSolution));
      if (newSolution.sumFilledBoxes < oldSolution.sumFilledBoxes) updateHorizontalClues();
    }
  }

  /// Updates the vertical clues based on the current solution.
  ///
  /// This function recalculates the vertical clues by analyzing the current solution string.
  /// It identifies sequences of filled boxes ('1') and updates the vertical clues accordingly.
  void updateVerticalClues() {
    final RegExp regExp = RegExp(r'1+'); // Match one or more consecutive ones
    final List<List<int>> newVerticalClues = state.verticalClues;

    for (int row = 0; row < state.height; row++) {
      final Iterable<RegExpMatch> rowMatches = regExp.allMatches(state.solution.getRowIsolate(row, state.width));
      final List<int> rowClues = rowMatches.map((RegExpMatch match) => match.group(0)!.length).toList();
      newVerticalClues[row] = rowClues.isNotEmpty ? rowClues : <int>[0];
    }

    emit(state.copyWith(verticalClues: newVerticalClues));
  }

  /// Updates the horizontal clues based on the current solution.
  ///
  /// This function recalculates the horizontal clues by analyzing the current solution string.
  /// It identifies sequences of filled boxes ('1') and updates the horizontal clues accordingly.
  void updateHorizontalClues() {
    final RegExp regExp = RegExp(r'1+'); // Match one or more consecutive ones
    final List<List<int>> newHorizontalClues = state.horizontalClues;

    for (int column = 0; column < state.width; column++) {
      final Iterable<RegExpMatch> columnMatches = regExp.allMatches(state.solution.getColumnIsolate(column, state.width));
      final List<int> columnClues = columnMatches.map((RegExpMatch match) => match.group(0)!.length).toList();
      newHorizontalClues[column] = columnClues.isNotEmpty ? columnClues : <int>[0];
    }

    emit(state.copyWith(horizontalClues: newHorizontalClues));
  }

  /// Updates the state of a specific box in the solution.
  ///
  /// This function toggles the state of a specific box in the solution string between filled ('1') and empty ('?').
  /// It also optionally updates the clues based on the new state of the box.
  ///
  /// Parameters:
  /// - [boxIndex]: The index of the box to update.
  /// - [autoUpdateClues]: Whether to automatically update the clues after updating the box.
  void updateBox(int boxIndex, [bool autoUpdateClues = true]) {
    if (boxIndex < 0) return;

    final bool isEmpty = state.solution.characterAt(boxIndex) == '?';
    emit(state.copyWith(solution: state.solution.replaceRange(boxIndex, boxIndex + 1, isEmpty ? '1' : '?')));

    if (autoUpdateClues) updateClues(boxIndex, isEmpty);
  }

  /// Updates the clues based on the state of a specific box.
  ///
  /// This function recalculates the clues for the row and column of a specific box in the solution string.
  /// It identifies sequences of filled boxes ('1') and updates the clues accordingly.
  ///
  /// Parameters:
  /// - [boxIndex]: The index of the box.
  /// - [isEmpty]: Whether the box is empty.
  void updateClues(int boxIndex, bool isEmpty) {
    final int row = boxIndex ~/ state.width;
    final int column = boxIndex % state.width;

    final RegExp regExp = RegExp(r'1+'); // Match one or more consecutive ones

    final Iterable<RegExpMatch> rowMatches = regExp.allMatches(state.solution.getRowIsolate(row, state.width));
    final List<int> rowClues = rowMatches.map((RegExpMatch match) => match.group(0)!.length).toList();

    final Iterable<RegExpMatch> columnMatches = regExp.allMatches(state.solution.getColumnIsolate(column, state.width));
    final List<int> columnClues = columnMatches.map((RegExpMatch match) => match.group(0)!.length).toList();

    final List<List<int>> newVerticalClues = state.verticalClues;
    newVerticalClues[row] = rowClues.isNotEmpty ? rowClues : <int>[0];

    final List<List<int>> newHorizontalClues = state.horizontalClues;
    newHorizontalClues[column] = columnClues.isNotEmpty ? columnClues : <int>[0];

    emit(
      state.copyWith(
        verticalClues: newVerticalClues,
        horizontalClues: newHorizontalClues,
        editingSettings: (isEmpty ? EditingSettings.paintMode : EditingSettings.eraseMode).copyWith(
          updateOnPanEnd: state.editingSettings.updateOnPanEnd,
        ),
      ),
    );
  }

  /// Handles the pan gesture to update the state of a box.
  ///
  /// This function updates the state of a box based on the current editing mode (paint or erase) during a pan gesture.
  ///
  /// Parameters:
  /// - [boxIndex]: The index of the box being panned.
  void onPan(int boxIndex) {
    if (boxIndex < 0 || boxIndex >= state.solution.length) return;

    if (state.solution.characterAt(boxIndex) == '?' && state.editingSettings.paint) {
      updateBox(boxIndex, !state.editingSettings.updateOnPanEnd);
    } else if (state.solution.characterAt(boxIndex) == '1' && state.editingSettings.erase) {
      updateBox(boxIndex, !state.editingSettings.updateOnPanEnd);
    }
  }

  /// Handles the end of a pan gesture to update the clues.
  ///
  /// This function updates the horizontal and vertical clues after a pan gesture ends.
  ///
  /// Parameters:
  /// - [boxIndex]: The index of the box where the pan ended.
  void onPanEnd(int boxIndex) {
    if (boxIndex < 0) return;

    updateHorizontalClues();
    updateVerticalClues();
  }

  /// Sets the selected line for editing.
  ///
  /// This function sets the selected line (either horizontal or vertical) for editing clues.
  ///
  /// Parameters:
  /// - [axis]: The axis of the selected line (horizontal or vertical).
  /// - [index]: The index of the selected line.
  /// - [clues]: The clues for the selected line.
  void setSelectedLine(Axis axis, int index, List<int> clues) {
    emit(state.copyWith(selectedLine: SelectedLine(axis: axis, index: index, clues: clues)));
  }

  /// Updates the selected line with new clues.
  ///
  /// This function updates the clues for the selected line based on a comma-separated string of new clues.
  ///
  /// Parameters:
  /// - [line]: The new clues for the selected line as a comma-separated string.
  void updateSelectedLine(String line) {
    final List<int> list = line.split(',').map((String e) => int.parse(e.trim())).where((e) => e != 0).toList();
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

  /// Toggles the setting for updating clues on pan end.
  ///
  /// This function toggles the setting that determines whether clues should be updated at the end of a pan gesture.
  void updateEditingSettingsOnPanEnd() {
    emit(state.copyWith(editingSettings: state.editingSettings.copyWith(updateOnPanEnd: !state.editingSettings.updateOnPanEnd)));
  }
}
