import 'package:flutter/material.dart';
import 'package:nonogram/config/app_theme.dart';
import 'package:nonogram/pages/game/nonogram_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
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
