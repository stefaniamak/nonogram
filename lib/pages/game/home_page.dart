import 'package:flutter/material.dart';
import 'package:nonogram/nono_tabs_page.dart';

class HomePage extends StatelessWidget {
  static const String route = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body());
    return NonoTabsPage(
      body: body(),
    );
  }

  Column body() {
    return const Column(
      children: [
        Text('game home pageeeeeeeeee'),
        Expanded(
          child: Text('drowing'),
          // child: SizedBox(
          //   width: 200, //double.infinity,
          //   height: 200, //double.infinity,
          //   child: GridPaper(
          //     color: Colors.black,
          //     interval: 100,
          //     divisions: 1,
          //     subdivisions: 5,
          //   ),
          // ),
        ),
      ],
    );
  }
}
