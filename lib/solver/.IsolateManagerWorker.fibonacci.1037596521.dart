import 'line_solver_simpler.dart';
import 'package:isolate_manager/isolate_manager.dart';

main() {
  IsolateManagerFunction.workerFunction(fibonacci);
}
