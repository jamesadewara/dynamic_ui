import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// A cross-platform floating action button
class DynamicFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final IconData? icon;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool mini;

  const DynamicFAB({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? _defaultBackground(context);
    final fg = foregroundColor ?? _defaultForeground(context);

    if (Platform.isIOS) {
      return CupertinoButton(
        color: bg,
        padding: EdgeInsets.symmetric(
          horizontal: mini ? 12 : 20,
          vertical: mini ? 8 : 14,
        ),
        onPressed: onPressed,
        child: icon != null
            ? Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(icon, size: mini ? 16 : 20, color: fg),
                const SizedBox(width: 6),
                DefaultTextStyle(style: TextStyle(color: fg), child: child),
              ])
            : child,
      );
    }

    if (Platform.isWindows) {
      return fluent.FloatingActionButton(
        onPressed: onPressed,
        child: icon != null ? Icon(icon, color: fg) : child,
        backgroundColor: bg,
        tooltip: tooltip,
        mini: mini,
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: bg,
      foregroundColor: fg,
      mini: mini,
      child: icon != null ? Icon(icon, color: fg) : child,
    );
  }

  Color _defaultBackground(BuildContext context) {
    if (Platform.isIOS) return CupertinoColors.activeBlue;
    if (Platform.isWindows) return fluent.Colors.blue;
    return Theme.of(context).colorScheme.primary;
  }

  Color _defaultForeground(BuildContext context) {
    return Colors.white;
  }
}
