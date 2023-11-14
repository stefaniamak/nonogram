import 'package:flutter/material.dart';
import 'package:nonogram/pages/on_boarding/on_boarding_page.dart';
import 'package:nonogram/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: MyRouter().router,
    );
  }
}
