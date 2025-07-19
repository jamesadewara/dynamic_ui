import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// A platform-adaptive badge component
class DynamicBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final double radius;

  const DynamicBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final pad = padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
    final bg = backgroundColor ?? _getDefaultBackground(context);
    final fg = textColor ?? _getDefaultForeground(context);

    if (Platform.isIOS) {
      return Container(
        padding: pad,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Text(label, style: TextStyle(color: fg, fontSize: 12)),
      );
    }

    if (Platform.isMacOS) {
      return Container(
        padding: pad,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Text(label, style: TextStyle(color: fg, fontSize: 12)),
      );
    }

    if (Platform.isWindows) {
      return fluent.InfoBadge(
        color: bg,
        foregroundColor: fg, 
        source: Text(label),
      );
    }

    // Default Material
    return Container(
      padding: pad,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(label, style: TextStyle(color: fg, fontSize: 12)),
    );
  }

  Color _getDefaultBackground(BuildContext context) {
    if (Platform.isIOS) return CupertinoColors.systemRed;
    if (Platform.isMacOS) return MacosColors.systemRedColor;
    if (Platform.isWindows) return fluent.Colors.red;
    return Colors.red;
  }

  Color _getDefaultForeground(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS || Platform.isWindows) {
      return Colors.white;
    }
    return Colors.white;
  }
}
