import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// A platform-adaptive grid view
class DynamicGridView extends StatelessWidget {
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;
  final List<Widget> children;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const DynamicGridView({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 8,
    this.crossAxisSpacing = 8,
    this.childAspectRatio = 1,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    final pad = padding ?? const EdgeInsets.all(8);

    if (Platform.isWindows) {
      return fluent.GridView.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
        padding: pad,
        children: children,
      );
    }

    if (Platform.isIOS || Platform.isMacOS) {
      return CustomScrollView(
        shrinkWrap: shrinkWrap,
        physics: physics ?? const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: pad,
            sliver: SliverGrid(
              delegate: SliverChildListDelegate(children),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: mainAxisSpacing,
                crossAxisSpacing: crossAxisSpacing,
                childAspectRatio: childAspectRatio,
              ),
            ),
          ),
        ],
      );
    }

    // Default: Material GridView
    return GridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      padding: pad,
      physics: physics,
      shrinkWrap: shrinkWrap,
      children: children,
    );
  }
}
