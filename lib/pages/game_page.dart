import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nonogram/utils/nonogram_grid.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(child: Text('Nonogram Game')),
          NonogramGrid(),
        ],
      ),
    );
  }
}
