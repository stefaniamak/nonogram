import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NonoButton extends StatelessWidget {
  const NonoButton({
    required this.label,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      child: Text(label),
    );
  }
}
