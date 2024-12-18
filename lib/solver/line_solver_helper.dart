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

  // TODO(stef): Update documentation
  /// The following 3 lines use the list of indexes of "?" in the line solution to find and replace them
  /// with "0"s in the entire puzzle solution String.
  ///
  /// We use RegEx for this task because the positions of a column in the solution String are spread out,
  /// unlike those of a row, which are contiguous.
  ///
  /// To find the global positions of each column index in the entire puzzle solution, we convert the local
  /// indexes from the line solution String to global indexes, taking into account the line we are searching.
  ///
  /// We create a RegEx to find and replace the specific characters in the global solution with "0".
  ///
  /// The RegEx searches for single character Strings with a specific number of characters before them.
  /// We generate the required number of characters based on the list of indexes from the local solution,
  /// and the RegEx matches Strings with exactly that many characters before them.
  ///
  /// The RegEx is `(?<=lookbehinds).` where [lookbehinds] is another RegEx String, generated from the local positions list.
  /// This String consists of multiple RegEx patterns like `(?<=^.{7}).` (where "7" is any number 0 or above),
  /// grouped and separated by "|". Let's break down the parts of the RegEx:
  ///
  /// Explaining `(?<=lookbehinds).`:
  ///   (?<=lookbehinds): Matches where [lookbehinds] is true.
  ///   .               : Matches the next character after the lookbehind condition.
  ///
  /// Explaining `lookbehinds`, e.g. ((?<=^.{7}).)|(?<=^.{10}).):
  ///   (?<=^.{7}).    :
  ///     (?<= : Lookbehind assertion to ensure what precedes the match...
  ///     ^    : Is the start of the String...
  ///     .    : Followed by any single character...
  ///     {7}  : Previous case repeated exactly 7 times (where "7" is any number 0 or above)...
  ///     .    : Matches the character immediately following this sequence.
  ///   |    : Or (alternates between the above generated number conditions).
  ///
  /// e.g. RegEx `((?<=^.{7}).)|(?<=^.{10}).)` applied to a String will return the 8th and 11th
  /// characters, as they have exactly 7 and 10 characters before them, respectively.
  ///
  /// We use this regex with replaceAllMapped to change the "?" characters to "0".
  ///
  Map<String, dynamic> getFilledInSolution(
    String currentSolution,
    int lineIndex,
    NonoAxis lineType,
    int nonogramWidth,
    List<int> charIndexes, [
    int clueKey = 0,
  ]) {
    String fullUpdatedSolution = currentSolution;
    final List<int> newFilledBoxes = <int>[];

    for (final int charIndex in charIndexes) {
      final int tempPos = lineType.getSolutionPosition(lineIndex, charIndex, nonogramWidth);
      newFilledBoxes.add(tempPos);
      fullUpdatedSolution =
          '${fullUpdatedSolution.substring(0, tempPos)}${clueKey == 0 ? '0' : '1'}${fullUpdatedSolution.substring(tempPos + 1)}';
    }
    return <String, dynamic>{
      'fullUpdatedSolution': fullUpdatedSolution,
      'newFilledBoxes': newFilledBoxes,
    };
  }

  Map<int, List<int>> getSideMostSolutionsMatches(
    List<List<String>> allLineSolutions,
    List<String> startingMostSolution,
    List<String> endingMostSolution,
    List<int> charIndexesOfQMarks,
  ) {
    // Generate a regex pattern to match any number except those in the exclusion list
    final String inclusionPattern = charIndexesOfQMarks.map((int e) => e).join('|');
    // Precompile regex patterns
    final RegExp regZeroFilledMatches = RegExp(r'\((' + inclusionPattern + r'), \[(0)\]\)');
    // Convert input lists to string once
    final String inputZeros = allLineSolutions.indexed.toList().toString();
    // Find matches using precompiled regex patterns
    final Iterable<RegExpMatch> matchesZeros = regZeroFilledMatches.allMatches(inputZeros);

    // Use a map to store the right number as keys and a set of left numbers as values for pairs that appear twice
    final Map<int, Set<int>> matchMap = <int, Set<int>>{};

    final Set<(int, String)> inputNumbersStart = startingMostSolution.indexed.toSet();
    final Set<(int, String)> inputNumbersEnd = endingMostSolution.indexed.toSet();
    final Set<(int, String)> duplicateInputNumbers = inputNumbersStart.intersection(inputNumbersEnd);

    for (final (int, String) match in duplicateInputNumbers) {
      final (int, String) pair = match;
      final int leftNumber = pair.$1;
      final int rightNumber = int.parse(pair.$2);
      if (rightNumber != 0 && charIndexesOfQMarks.contains(leftNumber)) {
        matchMap.putIfAbsent(rightNumber, () => <int>{});
        matchMap[rightNumber]!.add(leftNumber);
      }
    }

    if (matchesZeros.isNotEmpty) {
      matchMap.putIfAbsent(0, () => <int>{});
      matchMap[0]!.addAll(matchesZeros.map((RegExpMatch match) => int.parse(match.group(1)!)));
    }

    // Convert the sets to lists and print the final map
    return matchMap.map((int key, Set<int> value) => MapEntry<int, List<int>>(key, value.toList()));
  }
}
