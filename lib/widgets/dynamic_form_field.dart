import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// A platform-adaptive form field wrapper.
class DynamicFormField extends StatelessWidget {
  final String label;
  final Widget child;
  final String? errorText;
  final EdgeInsetsGeometry? padding;

  const DynamicFormField({
    super.key,
    required this.label,
    required this.child,
    this.errorText,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry fieldPadding = padding ?? const EdgeInsets.symmetric(vertical: 8);

    if (Platform.isIOS) {
      return Padding(
        padding: fieldPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            child,
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(errorText!, style: const TextStyle(color: CupertinoColors.systemRed, fontSize: 13)),
              ),
          ],
        ),
      );
    }

    if (Platform.isMacOS) {
      return Padding(
        padding: fieldPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: MacosTheme.of(context).typography.subheadline),
            const SizedBox(height: 6),
            child,
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(errorText!, style: const TextStyle(color: MacosColors.systemRedColor)),
              ),
          ],
        ),
      );
    }

    if (Platform.isWindows) {
      return Padding(
        padding: fieldPadding,
        child: fluent.InfoLabel(
          label: label,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              child,
              if (errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(errorText!, style: const TextStyle(color: fluent.Colors.red)),
                ),
            ],
          ),
        ),
      );
    }

    // Default: Material
    return Padding(
      padding: fieldPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 6),
          child,
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(errorText!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
        ],
      ),
    );
  }
}
