import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// A cross-platform card container
class DynamicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final Color? backgroundColor;

  const DynamicCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.elevation,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final pad = padding ?? const EdgeInsets.all(12);
    final mrg = margin ?? const EdgeInsets.all(8);
    final bg = backgroundColor ?? _getPlatformCardColor(context);
    final elev = elevation ?? 2.0;

    if (Platform.isIOS) {
      return Padding(
        padding: mrg,
        child: Container(
          padding: pad,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemGrey.withOpacity(0.2),
                blurRadius: elev * 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      );
    }

    if (Platform.isMacOS) {
      return Padding(
        padding: mrg,
        child: Container(
          padding: pad,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: MacosColors.systemGrayColor.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      );
    }

    if (Platform.isWindows) {
      return Padding(
        padding: mrg,
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: fluent.FluentTheme.of(context).shadowColor.withOpacity(0.2),
                blurRadius: elev * 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: pad,
          child: child,
        ),
      );
    }

    // Default Material
    return Padding(
      padding: mrg,
      child: Card(
        elevation: elev,
        color: bg,
        child: Padding(padding: pad, child: child),
      ),
    );
  }

  Color? _getPlatformCardColor(BuildContext context) {
    if (Platform.isMacOS) return MacosColors.controlBackgroundColor;
    if (Platform.isWindows) return fluent.FluentTheme.of(context).cardColor;
    if (Platform.isIOS) return CupertinoColors.systemGrey6;
    return Theme.of(context).cardColor;
  }
}