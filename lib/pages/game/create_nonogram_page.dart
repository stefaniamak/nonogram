import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/backend/cubits/create_nonogram/create_nonogram_cubit.dart';
import 'package:nonogram/backend/cubits/create_nonogram/create_nonogram_state.dart';
import 'package:nonogram/backend/cubits/nonogram_solver_cubit/nonogram_solver_cubit.dart';
import 'package:nonogram/backend/models/nonogram/clues.dart';
import 'package:nonogram/backend/models/nonogram/nonogram.dart';
import 'package:nonogram/config/app_colors.dart';
import 'package:nonogram/config/app_theme.dart';
import 'package:nonogram/pages/app_page.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';
import 'package:nonogram/pages/game/nonogram_page.dart';
import 'package:nonogram/painters/grid_painter.dart';
import 'package:nonogram/painters/nonogram_grid.dart';

/// A stateful widget that represents the page for creating a Nonogram puzzle.
class CreateNonogramPage extends StatefulWidget {
  /// Creates a [CreateNonogramPage].
  const CreateNonogramPage({super.key});

  @override
  State<CreateNonogramPage> createState() => _CreateNonogramPageState();
}

/// The state for the `CreateNonogramPage` widget.
class _CreateNonogramPageState extends State<CreateNonogramPage> {
  /// Controller for the text field used to input clues.
  final TextEditingController textEditingController = TextEditingController();

  /// The maximum size value for the Nonogram grid.
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
          children: <Widget>[
            buildTextField(createNonogramCubit),
            SizedBox(
              height: md.size.height - md.padding.vertical - 200 - kToolbarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: buildGridAndClues(state, createNonogramCubit, md),
                    ),
                  ),
                  buildVerticalSlided(state, createNonogramCubit),
                ],
              ),
            ),
            buildHorizontalSlider(state, createNonogramCubit),
            const SizedBox(height: 24),
            buildSolveButton(state, context),
            const SizedBox(height: 24),
            buildSettings(state, createNonogramCubit),
            SizedBox(height: md.padding.bottom + 12),
          ],
        );
      },
    );
  }

  /// Builds the text field for inputting clues.
  Row buildTextField(CreateNonogramCubit createNonogramCubit) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: textEditingController,
            onChanged: createNonogramCubit.updateSelectedLine,
          ),
        ),
      ],
    );
  }

  /// Builds the Nonogram grid and clues widget with the required parameters for the UI
  /// and all the grid gestures.
  NonogramGridAndClues buildGridAndClues(CreateNonogramState state, CreateNonogramCubit createNonogramCubit, MediaQueryData md) {
    return NonogramGridAndClues(
      clues: Clues(
        columns: state.horizontalClues,
        rows: state.verticalClues,
      ),
      onLineTap: (Axis axis, int index, List<int> cluesLine) {
        createNonogramCubit.setSelectedLine(axis, index, cluesLine);
        textEditingController.text = cluesLine.join(',');
      },
      gridStateParams: GridStateParams(solution: state.solution),
      gridGestures: GridGestures(
        onTap: createNonogramCubit.updateBox,
        onPan: createNonogramCubit.onPan,
        onPanEnd: state.editingSettings.updateOnPanEnd ? createNonogramCubit.onPanEnd : null,
      ),
      maxSize: Size(
        md.size.width > AppTheme.maxScreenConstraint ? 1000 : md.size.width * 0.8,
        md.size.height - md.padding.vertical - 200 - kToolbarHeight,
      ),
      padding: const EdgeInsets.all(32),
    );
  }

  /// Builds the vertical slider for adjusting the grid's total rows.
  RotatedBox buildVerticalSlided(CreateNonogramState state, CreateNonogramCubit createNonogramCubit) {
    return RotatedBox(
      quarterTurns: 1,
      child: Slider(
        value: state.height + 0.0,
        min: 1,
        max: _maxSizeValue + 0.0,
        divisions: _maxSizeValue,
        onChanged: (double value) {
          createNonogramCubit.updateHeight(value.ceil());
        },
      ),
    );
  }

  /// Builds the horizontal slider for adjusting the grid's total columns.
  Slider buildHorizontalSlider(CreateNonogramState state, CreateNonogramCubit createNonogramCubit) {
    return Slider(
      value: state.width + 0.0,
      min: 1,
      max: _maxSizeValue + 0.0,
      divisions: _maxSizeValue,
      onChanged: (double value) {
        createNonogramCubit.updateWidth(value.ceil());
      },
    );
  }

  /// Builds the button to solve the Nonogram puzzle by redirecting to the solving page.
  OutlinedButton buildSolveButton(CreateNonogramState state, BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        final Nonogram nonogram = state.nonogram;
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => BlocProvider<NonogramSolverCubit>(
              create: (_) => NonogramSolverCubit()..initialize(nonogram: nonogram),
              child: NonogramPage(nonogram: nonogram),
            ),
          ),
        );
      },
      child: const Text('SOLVE'),
    );
  }

  /// Builds the settings section for the Nonogram editor.
  Column buildSettings(CreateNonogramState state, CreateNonogramCubit createNonogramCubit) {
    return Column(
      children: <Widget>[
        const Text('--Settings--'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Switch(
              value: state.editingSettings.updateOnPanEnd,
              onChanged: (_) => createNonogramCubit.updateEditingSettingsOnPanEnd(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Update drag changes at onPanEnd',
                  style: TextStyle(color: state.editingSettings.updateOnPanEnd ? Colors.black : AppColors.disabled),
                ),
                Text(
                  'Update drag changes at onPan',
                  style: TextStyle(color: !state.editingSettings.updateOnPanEnd ? Colors.black : AppColors.disabled),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
