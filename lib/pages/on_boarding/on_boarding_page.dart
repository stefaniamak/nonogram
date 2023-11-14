import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nonogram/nono_tabs_page.dart';
import 'package:nonogram/pages/game/home_page.dart';

class OnBoardingPage extends StatelessWidget {
  static const String route = '/';

  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NonoTabsPage(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nonogram solver',
                      style: TextStyle(
                        fontSize: 90,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -5,
                        height: 0.8,
                      ),
                    ),
                    Text('This is the on boarding page for the game.'),
                    InkWell(
                      onTap: () => context.go(HomePage.route),
                      child: Text('Click here to go to home page'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
              child: Text('under construction.. :3'),
            ),
          ],
        ),
      ),
    );
  }
}
