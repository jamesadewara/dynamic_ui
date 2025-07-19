import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

class DynamicListView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const DynamicListView({
    super.key,
    required this.children,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoScrollbar(
        child: ListView(
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics ?? const BouncingScrollPhysics(),
          children: children,
        ),
      );
    }

    if (Platform.isMacOS) {
      return Scrollbar(
        child: ListView(
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics ?? const ClampingScrollPhysics(),
          children: children,
        ),
      );
    }

    if (Platform.isWindows) {
      return fluent.Scrollbar(
        controller: ScrollController(),
        child: ListView(
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics ?? const ClampingScrollPhysics(),
          children: children,
        ),
      );
    }

    // Default to Material
    return Scrollbar(
      child: ListView(
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
        children: children,
      ),
    );
  }
}
