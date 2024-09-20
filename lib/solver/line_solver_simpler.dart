import 'dart:convert';

import 'package:isolate_manager/isolate_manager.dart';

@isolateManagerWorker // Remove this annotation if you don't want to use the Worker
int fibonacci(int n) {
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
      final data = jsonDecode(message);
      List<dynamic> stack = data['stack'] ?? [];
      while (stack.isNotEmpty) {
        // Map<int, NonoAxis> line = stack.first;
        //
        // print('line: $line');

        controller.sendResult(
          jsonEncode(
            {
              'progress': {
                'stack': 'progress thingy',
              }
            },
          ),
        );
        stack.removeLast();
      }

      // This is a final value.
      return jsonEncode({'result': message});
    },
  );
}
