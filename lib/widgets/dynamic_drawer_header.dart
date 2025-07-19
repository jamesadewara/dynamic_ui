import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// A platform-adaptive drawer header
class DynamicDrawerHeader extends StatelessWidget {
  final Widget? avatar;
  final String title;
  final String? subtitle;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const DynamicDrawerHeader({
    super.key,
    this.avatar,
    required this.title,
    this.subtitle,
    this.backgroundColor,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? _defaultBackgroundColor(context);
    final ts = titleStyle ?? _defaultTitleStyle(context);
    final ss = subtitleStyle ?? _defaultSubtitleStyle(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: bg,
      child: Row(
        children: [
          if (avatar != null) ...[
            ClipOval(child: avatar!),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: ts),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!, style: ss),
                ],
              ],
            ),
          )
        ],
      ),
    );
  }

  Color _defaultBackgroundColor(BuildContext context) {
    if (Platform.isIOS) return CupertinoColors.systemGrey6;
    if (Platform.isMacOS) return MacosColors.controlBackgroundColor;
    if (Platform.isWindows) return fluent.Colors.white;
    return Theme.of(context).primaryColor.withOpacity(0.1);
  }

  TextStyle _defaultTitleStyle(BuildContext context) {
    if (Platform.isIOS) {
      return const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: CupertinoColors.label,
      );
    }
    if (Platform.isMacOS) {
      return MacosTheme.of(context).typography.headline.copyWith(fontWeight: FontWeight.bold);
    }
    if (Platform.isWindows) {
      return fluent.FluentTheme.of(context).typography.title!;
    }
    return Theme.of(context).textTheme.titleLarge!;
  }

  TextStyle _defaultSubtitleStyle(BuildContext context) {
    if (Platform.isIOS) {
      return const TextStyle(
        fontSize: 14,
        color: CupertinoColors.systemGrey,
      );
    }
    if (Platform.isMacOS) {
      return MacosTheme.of(context).typography.subheadline;
    }
    if (Platform.isWindows) {
      return fluent.FluentTheme.of(context).typography.body!;
    }
    return Theme.of(context).textTheme.bodyMedium!;
  }
}
