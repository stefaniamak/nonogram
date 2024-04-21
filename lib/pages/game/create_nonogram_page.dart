import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/game_loop/create_nonogram_state.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';

import '../../backend/models/clues.dart';
import '../../backend/models/nonogram.dart';
import '../../backend/models/nonogram_info.dart';
import 'nonogram_page.dart';

class CreateNonogramPage extends HookWidget {
  const CreateNonogramPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    // useCreateNonogramState
    var state = useCreateNonogramState();
    final TextEditingController textEditingController = useTextEditingController();

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          TextFormField(
            controller: state.selectedLineTextEditingController,
            onChanged: (String value) {
              print('TextFormField onChanged');
              state.updateSelectedLine(value);
            },
          ),
          Expanded(
            flex: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Center(
                    child: NonogramGridAndClues(
                      // nonogram: nonogramState.nonogram,
                      clues: Clues(
                        (c) => c
                          ..columns = ListBuilder(state.horizontalClues)
                          ..rows = ListBuilder(state.verticalClues),
                      ),
                      onLineTap: (Axis axis, int index, List<int> cluesLine) {
                        state.setSelectedLine(axis, index, cluesLine);
                      },
                      padding: const EdgeInsets.all(32),
                      boxItems: Size(state.width + 0, state.height + 0),
                      maxSize: Size(
                        MediaQuery.of(context).size.width * 0.8,
                        MediaQuery.of(context).size.height * 0.7,
                      ),
                    ),
                  ),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: Slider(
                    value: state.height + 0.0,
                    min: 1,
                    max: 50,
                    divisions: 50,
                    onChanged: (value) {
                      state.updateHeight(value.ceil());
                    },
                  ),
                ),
              ],
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
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => NonogramPage(
                    nonogram: Nonogram((n) => n
                      ..id = "-"
                      ..info = NonogramInfo((i) => i..title = "Custom").toBuilder()
                      ..note = "published,definitely unique,definitely line/color solvable"
                      ..clues = Clues(
                        (c) => c
                          ..columns = ListBuilder(state.horizontalClues)
                          ..rows = ListBuilder(state.verticalClues),
                      ).toBuilder()),
                  ),
                ),
              );
            },
            child: const Text('Solve'),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }
}
