import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    var state = useCreateNonogramState();

    print('nonogram width: ${state.nonogram.width}');

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: NonogramGridAndClues(
              // nonogram: nonogramState.nonogram,
              clues: state.nonogram.clues!,
              padding: const EdgeInsets.all(32),
              boxItems: Size(state.width + 0, state.height + 0),
              maxSize: Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * 0.8,
              ),
            ),
          ),
          Expanded(
            child: Slider(
              value: state.width + 0.0,
              min: 1,
              max: 50,
              divisions: 50,
              onChanged: (value) {
                state.updateWidth(value.ceil());
              },
            ),
          ),
          Text(state.width.toString()),
        ],
      ),
    );
  }
}
