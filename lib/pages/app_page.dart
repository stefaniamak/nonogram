import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'game/nonogram_list_page.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    required this.children,
    this.floatingActionButton,
    this.hasVerticalPadding = true,
    super.key,
  });

  final List<Widget> children;
  final Widget? floatingActionButton;
  final bool hasVerticalPadding;

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
      bottomNavigationBar: Container(
        color: Colors.white.withOpacity(0.8),
        padding: EdgeInsets.all(16),
        child: Text('Designed and Developed by Stefania Mak'),
      ),
      floatingActionButton: floatingActionButton,
      body: CustomScrollView(
        slivers: [
          SliverCrossAxisConstrained(
            maxCrossAxisExtent: 1200,
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
