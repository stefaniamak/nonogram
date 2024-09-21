import 'package:flutter/material.dart';
import 'package:nonogram/pages/widgets/blur_container.dart';
import 'package:sliver_tools/sliver_tools.dart';

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
        title: const Text('Nonogram Solver'),
        forceMaterialTransparency: true,
        // backgroundColor: Colors.white.withOpacity(0.8),
      ),
      extendBody: true,
      bottomNavigationBar: const BlurContainer(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [Expanded(child: Text('Designed and Developed by Stefania Mak | v0.5.2 [BETA]'))],
          ),
        ),
      ),
      floatingActionButton: floatingActionButton,
      body: CustomScrollView(
        slivers: [
          SliverCrossAxisConstrained(
            maxCrossAxisExtent: hasMaxCrossAxisExtend ? 1200 : MediaQuery.of(context).size.width,
            alignment: 0,
            child: SliverPadding(
              padding: EdgeInsets.symmetric(vertical: hasVerticalPadding ? 32 : 0, horizontal: 24),
              sliver: MultiSliver(children: [...children]),
            ),
          ),
          const SliverToBoxAdapter(child: BottomNavigationPadding()),
        ],
      ),
    );
  }
}
