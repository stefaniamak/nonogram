import 'package:flutter/material.dart';
import 'package:nonogram/nono_tabs_page.dart';

class HomePage extends StatelessWidget {
  static const String route = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NonoTabsPage(
      body: Center(
        child: Text('game home page'),
      ),
    );
  }
}
