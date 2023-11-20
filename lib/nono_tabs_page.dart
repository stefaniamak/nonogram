import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nonogram/pages/game/home_page.dart';
import 'package:nonogram/pages/on_boarding/on_boarding_page.dart';

class NonoTabsPage extends StatelessWidget {
  final Widget body;

  const NonoTabsPage({required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: body),
          // todo: add tab navigator #2 https://github.com/stefaniamak/nonogram/issues/2
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).padding.top,
            child: Row(
              children: [
                const SizedBox(width: 16),
                InkWell(
                  onTap: () => context.go(OnBoardingPage.route),
                  child: const Text('intro'),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () => context.go(HomePage.route),
                  child: const Text('game'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
