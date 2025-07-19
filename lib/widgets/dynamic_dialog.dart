import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// Platform-aware dialog with consistent parameters.
class DynamicDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    required List<DynamicDialogAction> actions,
  }) async {
    if (Platform.isIOS) {
      await showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: actions
              .map(
                (a) => CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    a.onPressed?.call();
                  },
                  isDestructiveAction: a.isDestructive,
                  isDefaultAction: a.isDefault,
                  child: Text(a.label),
                ),
              )
              .toList(),
        ),
      );
    } else if (Platform.isMacOS) {
      await showMacosAlertDialog(
        context: context,
        builder: (_) => MacosAlertDialog(
          appIcon: const FlutterLogo(size: 32),
          title: Text(title),
          message: Text(content),
          primaryButton: PushButton(
            controlSize: ControlSize.large,
            onPressed: () {
              Navigator.of(context).pop();
              actions.first.onPressed?.call();
            },
            child: Text(actions.first.label),
          ),
          secondaryButton: actions.length > 1
              ? PushButton(
                  controlSize: ControlSize.large,
                  onPressed: () {
                    Navigator.of(context).pop();
                    actions.last.onPressed?.call();
                  },
                  child: Text(actions.last.label),
                )
              : null,
        ),
      );
    } else if (Platform.isWindows) {
      await fluent.showDialog(
        context: context,
        builder: (_) => fluent.ContentDialog(
          title: Text(title),
          content: Text(content),
          actions: actions
              .map(
                (a) => fluent.Button(
                  onPressed: () {
                    Navigator.of(context).pop();
                    a.onPressed?.call();
                  },
                  child: Text(a.label),
                ),
              )
              .toList(),
        ),
      );
    } else {
      // Default to Material
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: actions
              .map(
                (a) => TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    a.onPressed?.call();
                  },
                  child: Text(a.label),
                ),
              )
              .toList(),
        ),
      );
    }
  }
}

/// Dialog action abstraction
class DynamicDialogAction {
  final String label;
  final VoidCallback? onPressed;
  final bool isDestructive;
  final bool isDefault;

  const DynamicDialogAction({
    required this.label,
    this.onPressed,
    this.isDestructive = false,
    this.isDefault = false,
  });
}
