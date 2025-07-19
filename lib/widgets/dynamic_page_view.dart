import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

/// A cross-platform swipeable page view
class DynamicPageView extends StatelessWidget {
  final List<Widget> children;
  final PageController? controller;
  final Axis scrollDirection;
  final bool pageSnapping;
  final ValueChanged<int>? onPageChanged;
  final ScrollPhysics? physics;

  const DynamicPageView({
    super.key,
    required this.children,
    this.controller,
    this.scrollDirection = Axis.horizontal,
    this.pageSnapping = true,
    this.onPageChanged,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final platformPhysics = physics ??
        (Platform.isIOS || Platform.isMacOS
            ? const BouncingScrollPhysics()
            : const ClampingScrollPhysics());

    return PageView(
      controller: controller,
      scrollDirection: scrollDirection,
      pageSnapping: pageSnapping,
      onPageChanged: onPageChanged,
      physics: platformPhysics,
      children: children,
    );
  }
}
