import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/backend/cubits/create_nonogram/create_nonogram_cubit.dart';
import 'package:nonogram/backend/cubits/nonogram_solver_cubit/nonogram_solver_cubit.dart';
import 'package:nonogram/backend/models/isolate/isolate_clues.dart';
import 'package:nonogram/config/app_color.dart';
import 'package:nonogram/pages/app_page.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';
import 'package:nonogram/pages/game/nonogram_page.dart';

import '../../backend/cubits/create_nonogram/create_nonogram_state.dart';

class CreateNonogramPage extends StatefulWidget {
  const CreateNonogramPage({
    super.key,
  });

  @override
  State<CreateNonogramPage> createState() => _CreateNonogramPageState();
}

class _CreateNonogramPageState extends State<CreateNonogramPage> {
  final TextEditingController textEditingController = TextEditingController();
  final int _maxSizeValue = 75;

  @override
  Widget build(BuildContext context) {
    final CreateNonogramCubit createNonogramCubit = context.read<CreateNonogramCubit>();
    final MediaQueryData md = MediaQuery.of(context);
    return BlocConsumer<CreateNonogramCubit, CreateNonogramState>(
      listener: (BuildContext context, CreateNonogramState state) {},
      builder: (_, CreateNonogramState state) {
        return AppPage(
          hasVerticalPadding: false,
          children: [
            // SizedBox(height: md.padding.top),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: textEditingController,
                    onChanged: (String value) {
                      createNonogramCubit.updateSelectedLine(value);
                    },
                  ),
                ),
                // TODO(stef): I'll see if I'll restore the bellow
                // IconButton(
                //   onPressed: () => createNonogramCubit.togglePaintMode(),
                //   color: state.editingSettings.paint ? Colors.green : Colors.black,
                //   icon: const Icon(Icons.draw),
                // ),
                // IconButton(
                //   onPressed: () => createNonogramCubit.toggleEraseMode(),
                //   color: state.editingSettings.erase ? Colors.green : Colors.black,
                //   icon: const Icon(Icons.edit_off),
                // ),
              ],
            ),
            SizedBox(
              height: md.size.height - md.padding.vertical - 200 - kToolbarHeight, //* 0.58,
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
                          createNonogramCubit.setSelectedLine(axis, index, cluesLine);
                          textEditingController.text = cluesLine.join(',');
                        },
                        padding: const EdgeInsets.all(32),
                        boxItems: Size(state.width + 0, state.height + 0),
                        maxSize: Size(
                          (md.size.width) > 1200 ? 1000 : (md.size.width * 0.8),
                          md.size.height - md.padding.vertical - 200 - kToolbarHeight,
                        ),
                        onTap: (int index) {
                          if (index > -1) createNonogramCubit.updateBox(index);
                        },
                        onPan: (int index) {
                          if (index > -1) createNonogramCubit.onPan(index);
                        },
                        onPanEnd: state.editingSettings.updateOnPanEnd
                            ? (int index) {
                                if (index > -1) createNonogramCubit.onPanEnd(index);
                              }
                            : null,
                      ),
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 1,
                    child: Slider(
                      value: state.height + 0.0,
                      min: 1,
                      max: _maxSizeValue + 0.0,
                      divisions: _maxSizeValue,
                      onChanged: (value) {
                        createNonogramCubit.updateHeight(value.ceil());
                      },
                    ),
                  ),
                ],
              ),
            ),
            Slider(
              value: state.width + 0.0,
              min: 1,
              max: _maxSizeValue + 0.0,
              divisions: _maxSizeValue,
              onChanged: (value) {
                createNonogramCubit.updateWidth(value.ceil());
              },
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () {
                final nonogram = state.nonogram;
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

            const SizedBox(height: 24),
            Column(
              children: [
                const Text('--Settings--'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Switch(
                      value: state.editingSettings.updateOnPanEnd,
                      onChanged: (_) => createNonogramCubit.updateEditingSettingsOnPanEnd(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Update drag changes at onPanEnd',
                          style: TextStyle(color: state.editingSettings.updateOnPanEnd ? Colors.black : AppColor.disabled),
                        ),
                        Text(
                          'Update drag changes at onPan',
                          style: TextStyle(color: !state.editingSettings.updateOnPanEnd ? Colors.black : AppColor.disabled),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: md.padding.bottom + 12),
          ],
        );
      },
    );
  }
}
