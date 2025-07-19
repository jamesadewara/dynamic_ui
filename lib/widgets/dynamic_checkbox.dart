import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

class DynamicCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final Color? activeColor;

  const DynamicCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final Widget checkbox;

    if (Platform.isIOS) {
      // No native checkbox in iOS, fallback to switch
      checkbox = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor ?? CupertinoColors.activeGreen,
          ),
          if (label != null) const SizedBox(width: 8),
          if (label != null)
            Text(label!, style: CupertinoTheme.of(context).textTheme.textStyle),
        ],
      );
    } else if (Platform.isMacOS) {
      checkbox = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MacosCheckbox(
            value: value,
            onChanged: onChanged,
            // Remove activeColor as it's not available in MacosCheckbox
          ),
          if (label != null) const SizedBox(width: 8),
          if (label != null) Text(label!),
        ],
      );
    } else if (Platform.isWindows) {
      checkbox = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          fluent.Checkbox(
            checked: value,
            onChanged: (v) => onChanged?.call(v ?? false),
            // Remove activeColor as it's not available in fluent.Checkbox
          ),
          if (label != null) const SizedBox(width: 8),
          if (label != null)
            Text(label!, style: fluent.FluentTheme.of(context).typography.body),
        ],
      );
    } else {
      checkbox = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: value,
            onChanged: (v) => onChanged?.call(v ?? false),
            activeColor: activeColor,
          ),
          if (label != null) const SizedBox(width: 8),
          if (label != null) Text(label!),
        ],
      );
    }

    return checkbox;
  }
}