import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/pages/game/nonogram_list_page.dart';
import 'package:nonogram/router.dart';

import 'backend/cubits/nonogram_solver_cubit/nonogram_solver_cubit.dart';
import 'config/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<NonogramSolverCubit>(create: (_) => NonogramSolverCubit()), //..initialize()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.defaultTheme,
        home: const NonogramListPage(),
      ),
    );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: MyRouter().router,
    );
  }
}
