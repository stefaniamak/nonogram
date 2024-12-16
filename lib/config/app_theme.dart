import 'package:flutter/material.dart';
import 'package:nonogram/config/app_colors.dart';
import 'package:nonogram/config/slider_theme/app_slider_track_shape.dart';

/// A class that defines the theme settings for the application.
class AppTheme {
  /// The radius for the slider track corners.
  static Radius sliderTrackRadius = const Radius.circular(8);

  /// The maximum screen width constraint.
  static double maxScreenConstraint = 1200;

  /// The medium screen width constraint.
  static double mediumScreenConstraint = 700;

  /// The maximum width for the puzzle information box.
  static double maxInfoBoxWidth = 460;

  /// Checks if the screen width has reached the maximum constraint.
  ///
  /// Returns true if the screen width is greater than [maxScreenConstraint].
  static bool hasReachedMaxWidth(BuildContext context) {
    return MediaQuery.of(context).size.width > maxScreenConstraint;
  }

  /// Checks if the screen width has reached the medium constraint.
  ///
  /// Returns true if the screen width is greater than [mediumScreenConstraint].
  static bool hasReachedMediumWidth(BuildContext context) {
    return MediaQuery.of(context).size.width > mediumScreenConstraint;
  }

  /// Determines the maximum number of columns for the page layout.
  ///
  /// Returns 3 if the screen width has reached the maximum constraint,
  /// 2 if it has reached the medium constraint, and 1 otherwise.
  static int maxPageColumns(BuildContext context) {
    return hasReachedMaxWidth(context) ? 3 : (hasReachedMediumWidth(context) ? 2 : 1);
  }

  /// Creates a rounded rectangle shape for the slider track.
  ///
  /// The [left], [top], [right], and [bottom] parameters define the rectangle's boundaries.
  static RRect sliderTrackShape(double left, double top, double right, double bottom) {
    return RRect.fromLTRBAndCorners(
      left,
      top,
      right,
      bottom,
      topRight: AppTheme.sliderTrackRadius,
      topLeft: AppTheme.sliderTrackRadius,
      bottomRight: AppTheme.sliderTrackRadius,
      bottomLeft: AppTheme.sliderTrackRadius,
    );
  }

  /// Returns the default theme settings for the application.
  static ThemeData get defaultTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      filledButtonTheme: FilledButtonThemeData(
        style: _defaultButtonStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) => (states.contains(WidgetState.disabled)) ? AppColors.black20 : Colors.yellowAccent,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(style: _defaultButtonStyle),
      sliderTheme: SliderThemeData(
        trackHeight: 6,
        activeTickMarkColor: Colors.white,
        activeTrackColor: Colors.black,
        inactiveTrackColor: Colors.white,
        inactiveTickMarkColor: Colors.black,
        disabledActiveTrackColor: AppColors.disabled,
        disabledInactiveTrackColor: AppColors.disabled,
        thumbColor: Colors.black,
        overlayColor: Colors.grey.withOpacity(0.25),
        trackShape: const AppSliderTrackShape(),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
        overlayShape: SliderComponentShape.noOverlay,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) => _sliderThumbColor(states)),
        thumbIcon: WidgetStateProperty.resolveWith<Icon>(
          (Set<WidgetState> states) => Icon(Icons.circle, color: _sliderThumbColor(states)),
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) => (states.contains(WidgetState.disabled))
              ? (states.contains(WidgetState.selected) ? AppColors.black20 : Colors.transparent)
              : (states.contains(WidgetState.selected) ? AppColors.black : AppColors.white),
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) => states.contains(WidgetState.disabled) ? AppColors.black20 : AppColors.black,
        ),
      ),
      chipTheme: ChipThemeData(
        labelStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        backgroundColor: Colors.black.withOpacity(0.8),
        side: BorderSide(color: Colors.black.withOpacity(0.8)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  /// Returns the color for the slider thumb based on its state.
  ///
  /// The [states] parameter provides the current state of the slider thumb.
  static Color _sliderThumbColor(Set<WidgetState> states) => states.contains(WidgetState.disabled)
      ? AppColors.black40
      : states.contains(WidgetState.selected)
          ? AppColors.white
          : AppColors.black;

  /// The default button style used in the theme.
  static final ButtonStyle _defaultButtonStyle = ButtonStyle(
    elevation: WidgetStateProperty.all<double>(0),
    foregroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) => (states.contains(WidgetState.disabled)) ? AppColors.disabled : AppColors.black90,
    ),
    backgroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) => (states.contains(WidgetState.disabled)) ? AppColors.black20 : Colors.white,
    ),
    overlayColor: WidgetStateProperty.all<Color>(Colors.black12.withOpacity(.025)),
    padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 8, vertical: 12)),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
    side: WidgetStateProperty.resolveWith<BorderSide>(
      (Set<WidgetState> states) => (states.contains(WidgetState.disabled))
          ? const BorderSide(color: AppColors.disabled, width: 2)
          : const BorderSide(width: 2),
    ),
  );
}
