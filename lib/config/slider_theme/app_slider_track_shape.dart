import 'package:flutter/material.dart';
import 'package:nonogram/config/app_colors.dart';
import 'package:nonogram/config/app_theme.dart';

/// The shape that will be used to draw the [Slider]'s track.
///
/// For more info, check out [RoundedRectSliderTrackShape] by Flutter.
class AppSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  /// Create a slider track that draws two rectangles with rounded outer edges.
  const AppSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting can be a no-op.
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final ColorTween inactiveTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: sliderTheme.inactiveTrackColor,
    );
    final Paint activePaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation)!;

    final (Paint leftTrackPaint, Paint rightTrackPaint) = switch (textDirection) {
      TextDirection.ltr => (activePaint, inactivePaint),
      TextDirection.rtl => (inactivePaint, activePaint),
    };

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    context.canvas.drawRRect(
      AppTheme.sliderTrackShape(
        trackRect.left,
        trackRect.top - (additionalActiveTrackHeight / 2),
        trackRect.right,
        trackRect.bottom + (additionalActiveTrackHeight / 2),
      ),
      rightTrackPaint..strokeWidth = 8,
    );
    context.canvas.drawRRect(
      AppTheme.sliderTrackShape(
        trackRect.left,
        trackRect.top - (additionalActiveTrackHeight / 2),
        thumbCenter.dx,
        trackRect.bottom + (additionalActiveTrackHeight / 2),
      ),
      leftTrackPaint,
    );

    final Paint paint = Paint()
      ..color = AppColors.black90 //Thumb Background Color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    context.canvas.drawRRect(
      AppTheme.sliderTrackShape(
        trackRect.left,
        trackRect.top - additionalActiveTrackHeight,
        trackRect.right,
        trackRect.bottom + additionalActiveTrackHeight,
      ),
      paint,
    );

    final bool showSecondaryTrack = (secondaryOffset != null) &&
        ((textDirection == TextDirection.ltr) ? (secondaryOffset.dx > thumbCenter.dx) : (secondaryOffset.dx < thumbCenter.dx));

    if (showSecondaryTrack) {
      final ColorTween secondaryTrackColorTween =
          ColorTween(begin: sliderTheme.disabledSecondaryActiveTrackColor, end: sliderTheme.secondaryActiveTrackColor);
      final Paint secondaryTrackPaint = Paint()..color = secondaryTrackColorTween.evaluate(enableAnimation)!;
      if (textDirection == TextDirection.ltr) {
        context.canvas.drawRRect(
          AppTheme.sliderTrackShape(
            thumbCenter.dx,
            trackRect.top,
            secondaryOffset.dx,
            trackRect.bottom,
          ),
          secondaryTrackPaint,
        );
      } else {
        context.canvas.drawRRect(
          AppTheme.sliderTrackShape(
            secondaryOffset.dx,
            trackRect.top,
            thumbCenter.dx,
            trackRect.bottom,
          ),
          secondaryTrackPaint,
        );
      }
    }
  }
}
