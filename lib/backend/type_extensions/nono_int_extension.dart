import 'package:intl/intl.dart';

/// Extension on Int to add utility methods for nonogram puzzles.
extension NonoIntExtension on int {
  /// Formats the integer as a string with a thousand separator.
  ///
  /// Returns the formatted integer as a string.
  String get commasFormatted => _thousandsFormatter.format(this);
}

/// A NumberFormat object to format integers with a thousand separator.
final NumberFormat _thousandsFormatter = NumberFormat("###,###.###", "tr_TR");
