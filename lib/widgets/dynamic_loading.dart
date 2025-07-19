import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// Adaptive loading indicator
class DynamicLoading extends StatelessWidget {
  final double? size;
  final Color? color;
  final String? label;

  const DynamicLoading({
    super.key,
    this.size,
    this.color,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final double effectiveSize = size ?? 24.0;

    Widget loader;

    if (Platform.isIOS) {
      loader = CupertinoActivityIndicator(
        radius: effectiveSize / 2,
        color: color ?? CupertinoColors.activeBlue,
      );
    } else if (Platform.isMacOS) {
      loader = ProgressCircle(
        value: null,
        size: effectiveSize,
      );
    } else if (Platform.isWindows) {
      loader = fluent.ProgressRing(
        strokeWidth: 3.0,
        activeColor: color ?? fluent.FluentTheme.of(context).accentColor,
      );
    } else {
      loader = SizedBox(
        width: effectiveSize,
        height: effectiveSize,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: color != null
              ? AlwaysStoppedAnimation<Color>(color!)
              : null,
        ),
      );
    }

    if (label != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loader,
          const SizedBox(height: 8),
          Text(
            label!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
    }

    return loader;
  }
}
