import 'package:flutter/material.dart';
import 'package:nonogram/pages/game/home_page.dart';
import 'package:nonogram/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: MyRouter().router,
    );
  }
}
