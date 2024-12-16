import 'package:flutter/material.dart';
import 'package:nonogram/config/app_theme.dart';
import 'package:nonogram/pages/game/nonogram_list_page.dart';

/// The main entry point of the application.
void main() {
  runApp(const MyApp());
}

/// A stateless widget that represents the root of the application.
class MyApp extends StatelessWidget {
  /// Creates a new instance of [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.defaultTheme,
      home: const NonogramListPage(),
    );
  }
}
