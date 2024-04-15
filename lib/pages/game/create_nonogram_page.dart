import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/game_loop/create_nonogram_state.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';

class CreateNonogramPage extends HookWidget {
  const CreateNonogramPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    // useCreateNonogramState
    var nonogramState = useCreateNonogramState();

    print('nonogram width: ${nonogramState.nonogram.width}');

    return Scaffold(
      body: Column(
        children: [
          NonogramGridAndClues(
            nonogram: nonogramState.nonogram,
            padding: const EdgeInsets.all(32),
            maxSize: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * 0.8,
            ),
          ),
          Slider(
            value: nonogramState.width + 0.0,
            min: 1,
            max: 50,
            divisions: nonogramState.width,
            onChanged: (value) {
              nonogramState.updateWidth(value.ceil());
            },
          ),
          Text(nonogramState.width.toString()),
        ],
      ),
    );
  }
}
