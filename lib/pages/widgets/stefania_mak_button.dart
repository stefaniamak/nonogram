import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/backend/cubits/nonogram_solver_cubit/nonogram_solver_cubit.dart';
import 'package:nonogram/backend/database/nonograms.dart';
import 'package:nonogram/pages/game/nonogram_page.dart';

class StefaniaMakButton extends StatefulWidget {
  const StefaniaMakButton({
    super.key,
  });

  @override
  State<StefaniaMakButton> createState() => _StefaniaMakButtonState();
}

class _StefaniaMakButtonState extends State<StefaniaMakButton> {
  List<Color> get splashColors => <Color>[
        Colors.grey,
        Colors.red,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.deepPurple,
        Colors.orange,
        Colors.pink,
        Colors.purple,
        Colors.teal,
        Colors.cyan,
        Colors.indigo,
        Colors.amber,
        Colors.lime,
        Colors.lightBlue,
        Colors.lightGreen,
        Colors.deepOrange,
        Colors.blueGrey,
        Colors.black,
      ];

  int index = 0;

  Color get randomColor => splashColors[DateTime.now().second % splashColors.length];

  int clickCount = 0;
  Timer? resetTimer;

  void handleClick() {
    // Cancel the existing timer if it exists
    resetTimer?.cancel();

    // Increment the click count
    clickCount++;

    // Check if the click count has reached 10
    if (clickCount == 10) {
      // Trigger the desired function
      onTenClicks();
      // Reset the click count
      clickCount = 0;
    } else {
      // Start a new timer to reset the click count after 2 seconds
      resetTimer = Timer(const Duration(seconds: 2), () {
        clickCount = 0;
      });
    }
  }

  void onTenClicks() => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider<NonogramSolverCubit>(
            create: (_) => NonogramSolverCubit()..initialize(nonogram: Nonograms.dev),
            child: NonogramPage(nonogram: Nonograms.dev),
          ),
        ),
      );

  @override
  void dispose() {
    // Dispose of the timer when the widget is removed
    resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        overlayColor: splashColors[index],
      ),
      onPressed: () {
        setState(() {
          index = (index + 1) % splashColors.length;
          handleClick();
        });
      },
      child: const Text('Stefania Mak', style: TextStyle(color: Colors.black)),
    );
  }
}
