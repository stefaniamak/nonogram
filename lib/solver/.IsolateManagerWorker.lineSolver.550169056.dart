import 'package:isolate_manager/isolate_manager.dart';

import 'line_solver_isolate.dart';

main() {
  IsolateManagerFunction.workerFunction(lineSolver);
}
