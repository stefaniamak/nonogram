import 'package:flutter/material.dart';
import 'package:nonogram/config/app_theme.dart';
import 'package:nonogram/pages/widgets/blur_container.dart';
import 'package:sliver_tools/sliver_tools.dart';

/// A stateless widget wrapper for every app page.
///
/// This widget updates its children width automatically,
/// based on the screen size.
class AppPage extends StatelessWidget {
  /// Provides the wrapped page with the app's style and screen functionalities.
  ///
  /// The [children] parameter must not be null.
  /// The [floatingActionButton], [hasVerticalPadding], and [hasMaxCrossAxisExtend]
  /// parameters are optional.
  const AppPage({
    required this.children,
    this.floatingActionButton,
    this.hasVerticalPadding = true,
    this.hasMaxCrossAxisExtend = true,
    super.key,
  });

  /// The list of widgets to display as the main content of the page.
  final List<Widget> children;

  /// An optional floating action button to display on the page.
  final Widget? floatingActionButton;

  /// Whether to include vertical padding around the main content.
  final bool hasVerticalPadding;

  /// Whether to constrain the maximum cross-axis extent of the main content,
  /// based on the screen width.
  final bool hasMaxCrossAxisExtend;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Flutter Nonogram Solver'),
        forceMaterialTransparency: true,
        // backgroundColor: Colors.white.withOpacity(0.8),
      ),
      extendBody: true,
      bottomNavigationBar: const BlurContainer(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: <Widget>[Expanded(child: Text('Designed and Developed by Stefania Mak | v0.8.1'))],
          ),
        ),
      ),
      floatingActionButton: floatingActionButton,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverCrossAxisConstrained(
            maxCrossAxisExtent: hasMaxCrossAxisExtend ? AppTheme.maxScreenConstraint : MediaQuery.of(context).size.width,
            child: SliverPadding(
              padding: EdgeInsets.symmetric(vertical: hasVerticalPadding ? 32 : 0, horizontal: 24),
              sliver: MultiSliver(children: <Widget>[...children]),
            ),
          ),
          const SliverToBoxAdapter(child: _BottomNavigationPadding()),
        ],
      ),
    );
  }
}

/// A stateless widget that adds padding to the bottom of the page
/// to account for the bottom navigation bar.
class _BottomNavigationPadding extends StatelessWidget {
  const _BottomNavigationPadding();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).padding.bottom);
  }
}
