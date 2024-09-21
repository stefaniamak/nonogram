import 'package:flutter/material.dart';
import 'package:nonogram/backend/database/nonograms.dart';
import 'package:nonogram/pages/game/nonogram_page.dart';

class HomePage extends StatelessWidget {
  static const String route = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NonogramPage(
        nonogram: Nonograms().cat,
      ),
    );
  }
}
