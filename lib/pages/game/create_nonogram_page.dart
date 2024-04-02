import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/models/nonogram.dart';
import 'package:nonogram/game_loop/create_nonogram_state.dart';
import 'package:nonogram/game_loop/nonogram_state.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';
import 'package:nonogram/solver/line_solver.dart';

class CreateNonogramPage extends HookWidget {
  const CreateNonogramPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    // useCreateNonogramState
    var nonogramState = useCreateNonogramState();

    return Scaffold(
      body: NonogramGridAndClues(
        nonogram: nonogramState.nonogram,
        padding: const EdgeInsets.all(32),
        maxSize: Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.8,
        ),
      ),
    );
  }
}
