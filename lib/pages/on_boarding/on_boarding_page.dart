import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nonogram/pages/game/home_page.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is the on boarding page for the game.'),
            InkWell(
              onTap: () => context.go(HomePage.route),
              child: Text('Click here to go to home page'),
            ),
          ],
        ),
      ),
    );
  }
}
