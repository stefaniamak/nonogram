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
          elevation: MaterialStateProperty.all<double>(0),
          foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColor.black20;
            }
            return AppColor.black90;
          }),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColor.black20;
            }
            return Colors.yellowAccent;
          }),
          overlayColor: MaterialStateProperty.all<Color>(Colors.black12.withOpacity(.025)),
          padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 8, vertical: 12)),
          // textStyle: MaterialStateProperty.all<TextStyle>(AppTextStyle.BOLD14),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          ),
          side: MaterialStateProperty.resolveWith<BorderSide>((Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return const BorderSide(color: AppColor.disabled, width: 2);
            }
            return const BorderSide(color: Colors.black, width: 2);
          }),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0),
          foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColor.black20;
            }
            return AppColor.black90;
          }),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColor.black20;
            }
            return Colors.white;
          }),
          overlayColor: MaterialStateProperty.all<Color>(Colors.black12.withOpacity(.025)),
          padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 8, vertical: 12)),
          // textStyle: MaterialStateProperty.all<TextStyle>(AppTextStyle.BOLD14),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          ),
          side: MaterialStateProperty.resolveWith<BorderSide>((Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
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
      ),
    );
  }
}
