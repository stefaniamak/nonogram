import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:nonogram/config/app_colors.dart';

/// A stateless widget that creates a container with a blurred background.
///
/// The `BlurContainer` widget allows for an optional color, child widget,
/// and border radius. It uses a `BackdropFilter` to apply a blur effect
/// to the background.
class BlurContainer extends StatelessWidget {
  /// Container with blurred background, meant to wrap some content.
  ///
  /// The [color], [child], and [borderRadius] parameters are optional.
  const BlurContainer({
    this.color,
    this.child,
    this.borderRadius = 0,
    super.key,
  });

  /// The color of the container background.
  /// If not provided, defaults to `AppColors.white` with 86% opacity.
  final Color? color;

  /// The child widget to display inside the container.
  final Widget? child;

  /// The border radius of the container.
  /// Defaults to 0 if not provided.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: (color ?? AppColors.white).withOpacity(.86),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
