import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// Cross-platform text widget with platform-adaptive defaults
class DynamicText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const DynamicText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? _getDefaultTextStyle(context);

    if (Platform.isWindows) {
      return fluent.Text(
        data,
        style: baseStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    // iOS/macOS still uses Material/Cupertino base with their font weights
    return Text(
      data,
      style: baseStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _getDefaultTextStyle(BuildContext context) {
    if (Platform.isIOS) {
      return const TextStyle(
        fontFamily: '.SF UI Text',
        fontSize: 16,
        color: CupertinoColors.label,
      );
    }

    if (Platform.isMacOS) {
      return MacosTheme.of(context).typography.body.copyWith(fontSize: 16);
    }

    if (Platform.isWindows) {
      return fluent.FluentTheme.of(context).typography.body!;
    }

    // Default Material
    return Theme.of(context).textTheme.bodyMedium!;
  }
}
