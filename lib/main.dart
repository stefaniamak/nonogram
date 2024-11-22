import 'package:flutter/material.dart';
import 'package:nonogram/pages/game/nonogram_list_page.dart';

import 'config/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.defaultTheme,
      home: const NonogramListPage(),
    );
  }
}
