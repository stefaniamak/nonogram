import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/backend/cubits/create_nonogram/create_nonogram_cubit.dart';
import 'package:nonogram/backend/cubits/create_nonogram/create_nonogram_state.dart';
import 'package:nonogram/backend/cubits/nonogram_solver_cubit/nonogram_solver_cubit.dart';
import 'package:nonogram/backend/models/isolate/isolate_clues.dart';
import 'package:nonogram/backend/models/isolate/isolate_nonogram.dart';
import 'package:nonogram/config/app_colors.dart';
import 'package:nonogram/config/app_theme.dart';
import 'package:nonogram/pages/app_page.dart';
import 'package:nonogram/pages/game/nonogram_grid_and_clues.dart';
import 'package:nonogram/pages/game/nonogram_page.dart';
import 'package:nonogram/painters/nonogram_grid.dart';

class CreateNonogramPage extends StatefulWidget {
  const CreateNonogramPage({super.key});

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

  NonogramGridAndClues buildGridAndClues(CreateNonogramState state, CreateNonogramCubit createNonogramCubit, MediaQueryData md) {
    return NonogramGridAndClues(
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
      boxItems: Size(state.width.toDouble(), state.height.toDouble()),
      maxSize: Size(
        md.size.width > AppTheme.maxScreenConstraint ? 1000 : md.size.width * 0.8,
        md.size.height - md.padding.vertical - 200 - kToolbarHeight,
      ),
      gridGestures: GridGestures(
        onTap: createNonogramCubit.updateBox,
        onPan: createNonogramCubit.onPan,
        onPanEnd: state.editingSettings.updateOnPanEnd ? createNonogramCubit.onPanEnd : null,
      ),
    );
  }

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

  OutlinedButton buildSolveButton(CreateNonogramState state, BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        final IsolateNonogram nonogram = state.nonogram;
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
