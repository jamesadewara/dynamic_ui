import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// A cross-platform icon component
class DynamicIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final String? semanticLabel;

  const DynamicIcon({
    super.key,
    required this.icon,
    this.size = 24.0,
    this.color,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? _getPlatformDefaultColor(context);

    if (Platform.isIOS) {
      return Icon(
        icon,
        size: size,
        color: iconColor,
        semanticLabel: semanticLabel,
      );
    }

    if (Platform.isMacOS) {
      return MacosIcon(
        icon,
        size: size,
        color: iconColor,
        semanticLabel: semanticLabel,
      );
    }

    if (Platform.isWindows) {
      return fluent.Icon(
        icon,
        size: size,
        color: iconColor,
        semanticLabel: semanticLabel,
      );
    }

    // Default: Material
    return Icon(
      icon,
      size: size,
      color: iconColor,
      semanticLabel: semanticLabel,
    );
  }

  Color? _getPlatformDefaultColor(BuildContext context) {
    if (Platform.isIOS) return CupertinoColors.systemGrey;
    if (Platform.isMacOS) return MacosColors.labelColor;
    if (Platform.isWindows) return fluent.FluentTheme.of(context).inactiveColor;
    return Theme.of(context).iconTheme.color;
  }
}
