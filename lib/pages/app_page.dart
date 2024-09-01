import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../config/app_color.dart';
import 'game/nonogram_list_page.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    required this.children,
    this.floatingActionButton,
    this.hasVerticalPadding = true,
    this.hasMaxCrossAxisExtend = true,
    super.key,
  });

  final List<Widget> children;
  final Widget? floatingActionButton;
  final bool hasVerticalPadding;
  final bool hasMaxCrossAxisExtend;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Nonogram Solver'),
        forceMaterialTransparency: true,
        // backgroundColor: Colors.white.withOpacity(0.8),
      ),
      extendBody: true,
      bottomNavigationBar: const AppBottomNavigationBar(),
      floatingActionButton: floatingActionButton,
      body: CustomScrollView(
        slivers: [
          SliverCrossAxisConstrained(
            maxCrossAxisExtent: hasMaxCrossAxisExtend ? 1200 : MediaQuery.of(context).size.width,
            alignment: 0,
            child: SliverPadding(
              padding: EdgeInsets.symmetric(vertical: hasVerticalPadding ? 32 : 0, horizontal: 16),
              sliver: MultiSliver(children: [...children]),
            ),
          ),
          const SliverToBoxAdapter(child: BottomNavigationPadding()),
        ],
      ),
    );
  }
}

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: AppColor.white.withOpacity(.86),
          ),
          child: ClipRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text('Designed and Developed by Stefania Mak'),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    return Container(
      color: Colors.white.withOpacity(0.8),
      padding: EdgeInsets.all(16),
      child: Text('Designed and Developed by Stefania Mak'),
    );
  }
}
