import 'package:isolate_manager/isolate_manager.dart';

@isolateManagerWorker // Remove this annotation if you don't want to use the Worker
int fibonacci(int n) {
  if (n == 0) return 0;
  if (n == 1) return 1;

  return fibonacci(n - 1) + fibonacci(n - 2);
}
