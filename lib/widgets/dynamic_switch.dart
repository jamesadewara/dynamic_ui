import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

class DynamicSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? thumbColor;

  const DynamicSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.thumbColor,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor ?? CupertinoColors.activeGreen,
      );
    }

    if (Platform.isMacOS) {
      return MacosSwitch(
        value: value,
        onChanged: onChanged,
      );
    }

    if (Platform.isWindows) {
      return fluent.ToggleSwitch(
        checked: value,
        onChanged: (v) => onChanged?.call(v),
      );
    }

    // Default to Material
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      thumbColor: thumbColor != null
          ? WidgetStateProperty.all<Color>(thumbColor!)
          : null,
    );
  }
}
