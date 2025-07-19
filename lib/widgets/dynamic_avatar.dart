import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// A cross-platform circular avatar widget
class DynamicAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final IconData? icon;
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const DynamicAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.icon,
    this.radius = 24.0,
    this.backgroundColor,
    this.foregroundColor,
  })  : assert(imageUrl != null || initials != null || icon != null,
            'Provide either imageUrl, initials or icon');

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? _defaultBackground(context);
    final fg = foregroundColor ?? Colors.white;

    Widget content;
    if (imageUrl != null) {
      content = CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: bg,
      );
    } else if (initials != null) {
      content = CircleAvatar(
        radius: radius,
        backgroundColor: bg,
        child: Text(
          initials!,
          style: TextStyle(color: fg, fontSize: radius * 0.6),
        ),
      );
    } else {
      content = CircleAvatar(
        radius: radius,
        backgroundColor: bg,
        child: Icon(icon, size: radius, color: fg),
      );
    }

    return content;
  }

  Color _defaultBackground(BuildContext context) {
    if (Platform.isIOS) return CupertinoColors.activeBlue;
    if (Platform.isMacOS) return MacosColors.systemBlueColor;
    if (Platform.isWindows) return fluent.Colors.blue;
    return Theme.of(context).primaryColor;
  }
}
