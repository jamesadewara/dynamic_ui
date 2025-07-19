import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// A platform-adaptive divider line
class DynamicDivider extends StatelessWidget {
  final double thickness;
  final double indent;
  final double endIndent;
  final Color? color;

  const DynamicDivider({
    super.key,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Padding(
        padding: EdgeInsets.only(left: indent, right: endIndent),
        child: Container(
          height: thickness,
          color: color ?? CupertinoColors.separator,
        ),
      );
    }

    if (Platform.isMacOS) {
      return Divider(
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
        color: color,
      );
    }

    if (Platform.isWindows) {
      return fluent.Padding(
        padding: EdgeInsets.only(left: indent, right: endIndent),
        child: fluent.Container(
          height: thickness,
          color: color ?? fluent.Colors.grey[30],
        ),
      );
    }

    // Default: Material Divider
    return Divider(
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }
}
