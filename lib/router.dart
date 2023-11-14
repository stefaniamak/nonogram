import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:nonogram/pages/game/home_page.dart';
import 'package:nonogram/pages/on_boarding/on_boarding_page.dart';

class MyRouter {
  MyRouter();

  dynamic get router => GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => OnBoardingPage(),
            routes: [
              GoRoute(
                path: HomePage.route.split('/').last,
                pageBuilder: (context, state) {
                  return _loggedInRoute(state);
                },
              ),
            ],
          ),
          GoRoute(
            path: HomePage.route,
            pageBuilder: (context, state) {
              return _loggedInRoute(state);
            },
          ),
        ],
      );

  CustomTransitionPage _loggedInRoute(GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: const HomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
          child: child,
        );
      },
    );
  }
}
