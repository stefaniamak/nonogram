import 'package:isolate_manager/isolate_manager.dart';
import 'package:nonogram/backend/type_extensions/nono_axis_extension.dart';

@isolateManagerCustomWorker
class LineSolverHelper {
  LineSolverHelper._();
  static final LineSolverHelper instance = LineSolverHelper._();

  /// Returns the solution line for a given line index and type (row or column) in a nonogram puzzle.
  ///
  /// - [lineIndex]: The index of the line to retrieve.
  /// - [nonogram]: The nonogram puzzle object containing the width of the puzzle.
  /// - [lineType]: The type of the line (row or column) to retrieve.
  ///
  /// Returns the solution line as a string.
  String getSolutionLine(String solution, int nonogramWidth, int lineIndex, NonoAxis lineType) {
    switch (lineType) {
      case NonoAxis.row:
        // Split the string into a list of characters, get the range for the specified row, join them back into a string, and remove unwanted characters.
        return solution
            .split('')
            .getRange(lineIndex * nonogramWidth, nonogramWidth * (lineIndex + 1))
            .join()
            .replaceAll(RegExp(r'[ (),]'), '');
      case NonoAxis.column:
        String columnSol = '';
        // Iterate through the string to collect the characters of the specified column.
        for (int solChar = lineIndex; solChar < solution.length; solChar += nonogramWidth) {
          columnSol += solution[solChar];
        }
        return columnSol;
    }
  }

  /// In the following 4 lines, we create a List<int> with all the index positions
  /// of question marks ("?") in a String. In our case, the String is the current line solution.
  ///
  /// We get the initialSolution of that line and create a list of characters with their indexes (`characters.indexed`).
  /// This indexed list includes the original characters matched with their positions in the String.
  /// e.g. String `0?1` has the result ((0, 0), (1, ?), (2, 1))
  ///
  /// We then convert this indexed list to a String using .toString() and use a RegEx search to get all
  /// the indexes of the `?` characters in the solution.
  ///
  /// The RegEx [charIndexesRegexp] pattern is:
  ///   [0-9]    -> Matches digits...
  ///   +        -> One or more of the previous case...
  ///   (?=, ?) -> That are followed by the String ", ?".
  ///
  /// After getting all the matches, we join them with commas (",") to form a single String.
  /// Then, we split this String by "," and parse its contents to integers.
  ///
  /// Now, we have a List<int> of all the indexes of the "?" characters in the solution.
  /// e.g. String "((0, 0), (1, ?), (2, 1))" results in [1].
  ///
  List<int> getCharIndexesOfQuestionMarks(String initialSolution) {
    final Iterable<(int, String)> initialSolutionIndexed = initialSolution.split('').indexed;

    final RegExp charIndexesRegexp = RegExp(r'[0-9]+(?=, \?)');
    // Find all matches
    final Iterable<Match> matches = charIndexesRegexp.allMatches(initialSolutionIndexed.toList().toString());
    // Extract the matched parts and join them with commas
    final List<int> result = matches.map((Match match) => match.group(0)).whereType<String>().map(int.parse).toList();

    return result;
  }

  /// Fills in the solution for a nonogram puzzle by replacing specific characters with '0' or '1'.
  ///
  /// - [currentSolution]: The current solution string of the nonogram puzzle.
  /// - [lineIndex]: The index of the line to process.
  /// - [lineType]: The type of the line (row or column) to process.
  /// - [nonogramWidth]: The width of the nonogram puzzle.
  /// - [charIndexes]: A list of character indexes to replace in the solution.
  /// - [clueKey]: An optional parameter to determine the replacement character (default is 0).
  ///
  /// This function iterates over the provided character indexes and calculates their positions
  /// in the solution string based on the line type (row or column) and the line index. It then
  /// replaces the characters at these positions with '0' or '1' depending on the value of [clueKey].
  ///
  /// Returns a map containing:
  /// - 'fullUpdatedSolution': The updated solution string.
  /// - 'newFilledBoxes': A list of new filled box positions.
  Map<String, dynamic> getFilledInSolution(
    String currentSolution,
    int lineIndex,
    NonoAxis lineType,
    int nonogramWidth,
    List<int> charIndexes, [
    int clueKey = 0,
  ]) {
    // Initialize the updated solution string with the current solution.
    String fullUpdatedSolution = currentSolution;
    // Initialize a list to keep track of the new filled box positions.
    final List<int> newFilledBoxes = <int>[];

    // Iterate over each character index in the provided list.
    for (final int charIndex in charIndexes) {
      // Calculate the position in the solution string based on the line type and index.
      final int tempPos = lineType.getSolutionPosition(lineIndex, charIndex, nonogramWidth);
      // Add the calculated position to the list of new filled boxes.
      newFilledBoxes.add(tempPos);
      // Update the solution string by replacing the character at the calculated position with '0' or '1'.
      fullUpdatedSolution =
          '${fullUpdatedSolution.substring(0, tempPos)}${clueKey == 0 ? '0' : '1'}${fullUpdatedSolution.substring(tempPos + 1)}';
    }

    // Return a map containing the updated solution string and the list of new filled box positions.
    return <String, dynamic>{
      'fullUpdatedSolution': fullUpdatedSolution,
      'newFilledBoxes': newFilledBoxes,
    };
  }
}
