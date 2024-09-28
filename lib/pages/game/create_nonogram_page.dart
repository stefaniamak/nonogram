import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nonogram/backend/cubits/nonogram_solver_cubit/nonogram_solver_cubit.dart';
import 'package:nonogram/backend/models/isolate/isolate_clues.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/game_loop/create_nonogram_state.dart';
import 'package:nonogram/pages/app_page.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';
import 'package:nonogram/pages/game/nonogram_page.dart';

class CreateNonogramPage extends HookWidget {
  const CreateNonogramPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    // useCreateNonogramState
    var state = useCreateNonogramState();
    final TextEditingController textEditingController = useTextEditingController();

    return AppPage(
      children: [
        // SizedBox(height: MediaQuery.of(context).padding.top),
        TextFormField(
          controller: state.selectedLineTextEditingController,
          onChanged: (String value) {
            print('TextFormField onChanged');
            state.updateSelectedLine(value);
          },
        ),
        // TODO(stef): restore
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          // flex: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Center(
                  child: NonogramGridAndClues(
                    // nonogram: nonogramState.nonogram,
                    solution: state.solution,
                    clues: IsolateClues(
                      columns: state.horizontalClues,
                      rows: state.verticalClues,
                    ),
                    onLineTap: (Axis axis, int index, List<int> cluesLine) {
                      state.setSelectedLine(axis, index, cluesLine);
                    },
                    padding: const EdgeInsets.all(32),
                    boxItems: Size(state.width + 0, state.height + 0),
                    maxSize: Size(
                      (MediaQuery.of(context).size.width) > 1200 ? 1000 : (MediaQuery.of(context).size.width * 0.8),
                      MediaQuery.of(context).size.height * 0.7,
                    ),
                    onTap: (int index) {
                      state.updateBox(index);
                    },
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
        Slider(
          value: state.width + 0.0,
          min: 1,
          max: 50,
          divisions: 50,
          onChanged: (value) {
            state.updateWidth(value.ceil());
          },
        ),
        const SizedBox(height: 24),
        // TODO(stef): restore
        OutlinedButton(
          onPressed: () {
            final nonogram = IsolateNonogram(
              id: "-",
              clues: IsolateClues(
                columns: state.horizontalClues,
                rows: state.verticalClues,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => BlocProvider(
                  create: (_) => NonogramSolverCubit()..initialize(nonogram: nonogram),
                  child: NonogramPage(nonogram: nonogram),
                ),
              ),
            );
          },
          child: const Text('SOLVE'),
        ),
        // SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
      ],
    );
  }
}
