import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// Type of progress indicator
enum DynamicProgressType {
  circular,
  linear,
}

/// Cross-platform progress indicator
class DynamicProgressIndicator extends StatelessWidget {
  final DynamicProgressType type;
  final double? value;
  final double? size;
  final Color? color;
  final bool center;

  const DynamicProgressIndicator({
    super.key,
    this.type = DynamicProgressType.circular,
    this.value,
    this.size,
    this.color,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    final indicator = _buildIndicator(context);

    return center ? Center(child: indicator) : indicator;
  }

  Widget _buildIndicator(BuildContext context) {
    final c = color ?? _defaultColor(context);

    if (type == DynamicProgressType.linear) {
      if (Platform.isIOS) {
        return CupertinoActivityIndicator(
          radius: size ?? 12,
        );
      } else if (Platform.isMacOS) {
        return MacosProgressBar(
          value: value,
        );
      } else if (Platform.isWindows) {
        return fluent.ProgressBar(
          value: value,
        );
      }

      return LinearProgressIndicator(
        value: value,
        color: c,
        minHeight: size ?? 4,
      );
    }

    // Circular
    if (Platform.isIOS) {
      return CupertinoActivityIndicator(radius: size ?? 12);
    }

    if (Platform.isMacOS) {
      return MacosProgressCircle(
        value: value,
        size: size ?? 24,
      );
    }

    if (Platform.isWindows) {
      return fluent.ProgressRing(
        value: value,
      );
    }

    return CircularProgressIndicator(
      value: value,
      strokeWidth: 4.0,
      color: c,
    );
  }

  Color _defaultColor(BuildContext context) {
    if (Platform.isIOS) return CupertinoColors.activeBlue;
    if (Platform.isMacOS) return MacosColors.systemBlueColor;
    if (Platform.isWindows) return fluent.Colors.blue;
    return Theme.of(context).colorScheme.primary;
  }
}
