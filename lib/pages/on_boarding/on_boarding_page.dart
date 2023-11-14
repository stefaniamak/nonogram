import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nonogram/pages/game/home_page.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
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
          // todo: add tab navigator #2 https://github.com/stefaniamak/nonogram/issues/2
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Row(
              children: [
                Text('intro'),
                SizedBox(width: 12),
                InkWell(
                  onTap: () => context.go(HomePage.route),
                  child: Text('game'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
