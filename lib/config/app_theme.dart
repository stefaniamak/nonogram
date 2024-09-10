import 'package:flutter/material.dart';
import 'package:nonogram/config/slider_theme/app_slider_track_shape.dart';

import 'app_color.dart';

class AppTheme {
  static Radius sliderTrackRadius = const Radius.circular(8);

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

  static ThemeData get defaultTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all<double>(0),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColor.disabled;
            }
            return AppColor.black90;
          }),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColor.black20;
            }
            return Colors.yellowAccent;
          }),
          overlayColor: WidgetStateProperty.all<Color>(Colors.black12.withOpacity(.025)),
          padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 8, vertical: 12)),
          // textStyle: WidgetStateProperty.all<TextStyle>(AppTextStyle.BOLD14),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          ),
          side: WidgetStateProperty.resolveWith<BorderSide>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return const BorderSide(color: AppColor.disabled, width: 2);
            }
            return const BorderSide(color: Colors.black, width: 2);
          }),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all<double>(0),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColor.black20;
            }
            return AppColor.black90;
          }),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColor.black20;
            }
            return Colors.white;
          }),
          overlayColor: WidgetStateProperty.all<Color>(Colors.black12.withOpacity(.025)),
          padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 8, vertical: 12)),
          // textStyle: WidgetStateProperty.all<TextStyle>(AppTextStyle.BOLD14),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          ),
          side: WidgetStateProperty.resolveWith<BorderSide>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return const BorderSide(color: AppColor.disabled, width: 2);
            }
            return const BorderSide(color: Colors.black, width: 2);
          }),
        ),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 6,
        activeTickMarkColor: Colors.white,
        activeTrackColor: Colors.black,
        inactiveTrackColor: Colors.white,
        inactiveTickMarkColor: Colors.black,
        disabledActiveTrackColor: AppColor.disabled,
        disabledInactiveTrackColor: AppColor.disabled,
        thumbColor: Colors.black,
        overlayColor: Colors.grey.withOpacity(0.25),
        trackShape: const AppSliderTrackShape(),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
        overlayShape: SliderComponentShape.noOverlay,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColor.black40;
          } else {
            return states.contains(WidgetState.selected) ? AppColor.white : AppColor.black;
          }
        }),
        thumbIcon: WidgetStateProperty.resolveWith<Icon>(
          (Set<WidgetState> states) {
            final Color thumbColor;
            if (states.contains(WidgetState.disabled)) {
              thumbColor = AppColor.black40;
            } else {
              thumbColor = states.contains(WidgetState.selected) ? AppColor.white : AppColor.black;
            }
            return Icon(Icons.circle, color: thumbColor);
          },
        ),
        trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return states.contains(WidgetState.selected) ? AppColor.black20 : Colors.transparent;
          } else {
            return states.contains(WidgetState.selected) ? AppColor.black : AppColor.white;
          }
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          return states.contains(WidgetState.disabled) ? AppColor.black20 : AppColor.black;
        }),
      ),
      chipTheme: ChipThemeData(
        labelStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        backgroundColor: Colors.black.withOpacity(0.8),
        side: BorderSide(color: Colors.black.withOpacity(0.8)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
