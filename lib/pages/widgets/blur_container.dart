import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:nonogram/config/app_color.dart';

class BlurContainer extends StatelessWidget {
  const BlurContainer({
    this.color,
    this.child,
    this.borderRadius = 0,
    super.key,
  });

  final Color? color;
  final Widget? child;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: (color ?? AppColor.white).withOpacity(.86),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: SizedBox(
                // width: MediaQuery.of(context).size.width,
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
