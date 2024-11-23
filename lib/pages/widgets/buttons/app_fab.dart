import 'package:flutter/material.dart';
import 'package:nonogram/pages/widgets/blur_container.dart';

/// A stateless widget that represents a floating action button with a blurred background.
///
/// The `AppFab` widget includes an icon and an onPressed callback function.
/// It uses a `BlurContainer` for the background and an `IconButton` for the button itself.
class AppFab extends StatelessWidget {
  /// Default FAB with app's theme.
  ///
  /// The [icon] and [onPressed] parameters must not be null.
  const AppFab({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  /// The icon to display inside the floating action button.
  final Widget icon;

  /// The callback function to be called when the button is pressed.
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return BlurContainer(
      color: Colors.yellowAccent,
      borderRadius: 32,
      child: Ink(
        width: 56,
        height: 56,
        decoration: const ShapeDecoration(
          shape: CircleBorder(),
        ),
        child: IconButton(
          icon: icon,
          color: Colors.black,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
