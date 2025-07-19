import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// Platform-adaptive slider widget
class DynamicSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final Color? activeColor;
  final Color? thumbColor;

  const DynamicSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.divisions,
    this.activeColor,
    this.thumbColor,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoSlider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
        activeColor: activeColor ?? CupertinoColors.activeBlue,
        thumbColor: thumbColor,
      );
    }

    if (Platform.isMacOS) {
      return MacosSlider(
        value: value,
        min: min,
        max: max,
        onChanged: onChanged,
        divisions: divisions,
      );
    }

    if (Platform.isWindows) {
      return fluent.Slider(
        value: value,
        min: min,
        max: max,
        onChanged: onChanged,
        divisions: divisions,
      );
    }

    // Default: Material
    return Slider(
      value: value,
      min: min,
      max: max,
      onChanged: onChanged,
      divisions: divisions,
      activeColor: activeColor,
      thumbColor: thumbColor,
    );
  }
}
