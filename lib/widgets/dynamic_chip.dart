import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// A platform-adaptive chip/tag widget
class DynamicChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final Color? backgroundColor;
  final Color? textColor;

  const DynamicChip({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.onDeleted,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final labelText = Text(
      label,
      style: TextStyle(color: textColor),
    );

    if (Platform.isIOS) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: backgroundColor ?? CupertinoColors.systemGrey5,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: textColor ?? CupertinoColors.label),
                const SizedBox(width: 6),
              ],
              labelText,
              if (onDeleted != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onDeleted,
                  child: const Icon(CupertinoIcons.clear_thick_circled, size: 18),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (Platform.isMacOS) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: backgroundColor ?? MacosColors.controlBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                MacosIcon(icon!, size: 18),
                const SizedBox(width: 6),
              ],
              labelText,
              if (onDeleted != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onDeleted,
                  child: const MacosIcon(CupertinoIcons.clear_circled, size: 18),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (Platform.isWindows) {
      return fluent.InfoBadge(
        color: backgroundColor,
        source: Column(children:[
          Text(label, style: TextStyle(color: textColor)),
         GestureDetector(
          onTap: onTap,
          child: fluent.Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: backgroundColor ?? fluent.Colors.grey[20],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: 6),
                ],
                Text(label),
                if (onDeleted != null) ...[
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: onDeleted,
                    child: const Icon(fluent.FluentIcons.clear, size: 16),
                  ),
                ],
              ],
            ),
          ),
        )])
      );
    }

    // Default: Material Chip
    return Chip(
      avatar: icon != null ? Icon(icon, size: 18) : null,
      label: labelText,
      backgroundColor: backgroundColor,
      onDeleted: onDeleted,
      deleteIcon: onDeleted != null ? const Icon(Icons.cancel, size: 18) : null,
      deleteIconColor: textColor,
      labelStyle: TextStyle(color: textColor),
    );
  }
}
