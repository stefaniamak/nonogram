import 'package:flutter/material.dart';

class NonoClues extends StatelessWidget {
  const NonoClues({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ClueBox extends StatelessWidget {
  final double side;
  final int numb;

  const ClueBox({required this.side, required this.numb, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: side,
      height: side,
      padding: const EdgeInsets.all(4),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(numb.toString()),
      ),
    );
  }
}
