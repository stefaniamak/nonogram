import 'dart:convert';

import 'package:isolate_manager/isolate_manager.dart';
import 'package:nonogram/backend/models/isolate/isolate_input.dart';

import '../backend/models/isolate/isolate_output.dart';
import '../backend/type_extensions/nono_axis_extension.dart';

@isolateManagerWorker // Remove this annotation if you don't want to use the Worker
int fibonacci(int n) {
  print('n: $n');
  if (n == 0) return 0;
  if (n == 1) return 1;

  return fibonacci(n - 1) + fibonacci(n - 2);
}

@isolateManagerWorker // Remove this annotation if you don't want to use the Worker
int lineSolver(int n) {
  return fibonacci(n);
}

// This is a progress function
@isolateManagerCustomWorker // Add this anotation for a custom function
void progressFunction(dynamic params) {
  IsolateManagerFunction.customFunction<String, int>(
    params,
    onEvent: (controller, message) {
      // This value is sent as the progress values.
      for (int i = 0; i < message; i++) {
        final progress = jsonEncode({'progress': i});
        controller.sendResult(progress);
      }

      // This is a final value.
      return jsonEncode({'result': message});
    },
  );
}

// This is a progress function
@isolateManagerCustomWorker // Add this anotation for a custom function
void lineSolverIsolate(dynamic params) {
  IsolateManagerFunction.customFunction<String, String>(
    params,
    onEvent: (controller, message) {
      print('message: $message');
      final IsolateInput input = IsolateInput.fromJson(jsonDecode(message));
      List<Map<int, NonoAxis>> stack = input.stack;
      IsolateOutput output = IsolateOutput(stack: stack);

      // lineSolver(10);

      while (stack.isNotEmpty) {
        Map<int, NonoAxis> line = stack.first;

        List<int> clues = (line.values.first == NonoAxis.row ? input.rows : input.columns).elementAt(line.keys.first);
        // loopSides(state, line.keys.first, clues, line.values.first);

        stack.removeAt(0);

        controller.sendResult(
          jsonEncode(
            {
              'progress': output.toJson(),
            },
          ),
        );
        stack.removeLast();
      }

      String test = 'asdf';
      print('test.characters: ${test.split('').toList()}');

      List<String> testList = test.split('').toList();

      // This is a final value.
      return jsonEncode({'result': testList});
    },
  );
}
