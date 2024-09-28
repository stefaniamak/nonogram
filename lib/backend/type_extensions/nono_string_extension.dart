extension NonoStringExtension on String {
  String characterAt(int index) => split('').toList().elementAt(index);

  int get sumFilledBoxes =>
      split('').fold(0, (previousValue, element) => previousValue + (element != '?' ? int.parse(element) : 0));

  bool isSameClueIndexWith(String element) => (this == element) && this != '?' && element != '0' && this != '?' && element != '0';

  String getRowIsolate(int lineIndex, int width) => split('')
      .toList()
      .getRange(lineIndex * width, width * (lineIndex + 1))
      .join()
      .replaceAll(' ', '')
      .replaceAll('(', '')
      .replaceAll(')', '')
      .replaceAll(',', '');

  String getColumnIsolate(int lineIndex, int width) {
    String columnSol = '';
    for (var solChar = lineIndex; solChar < split('').toList().length; solChar = solChar + width) {
      columnSol = '$columnSol${split('').toList().elementAt(solChar)}';
    }
    return columnSol;
  }
}
