import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// A cross-platform alert dialog
class DynamicAlertDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final List<Widget> actions;

  const DynamicAlertDialog({
    super.key,
    this.title,
    this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: title != null ? Text(title!) : null,
        content: content != null ? Text(content!) : null,
        actions: actions,
      );
    }

    if (Platform.isMacOS) {
      return MacosAlertDialog(
        appIcon: const FlutterLogo(size: 36),
        title: Text(title ?? "Alert"),
        message: Text(content ?? ""),
        primaryButton: _getMacosButton(context, 0) ?? PushButton(
          controlSize: ControlSize.large,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
        secondaryButton: _getMacosButton(context, 1),
      );
    }

    if (Platform.isWindows) {
      return fluent.ContentDialog(
        title: Text(title ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content ?? ""),
        actions: actions,
      );
    }

    // Default to Material
    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: content != null ? Text(content!) : null,
      actions: actions,
    );
  }

  /// Helper method to convert actions to MacOS buttons
  PushButton? _getMacosButton(BuildContext context, int index) {
    if (index >= actions.length) return null;
    
    final action = actions[index];
    
    // If the action is already a PushButton, return it
    if (action is PushButton) {
      return action;
    }
    
    // If it's a TextButton, extract its properties
    if (action is TextButton) {
      return PushButton(
        controlSize: ControlSize.large,
        onPressed: action.onPressed,
        child: action.child ?? const Text('OK'),
      );
    }
    
    // If it's an ElevatedButton, extract its properties
    if (action is ElevatedButton) {
      return PushButton(
        controlSize: ControlSize.large,
        onPressed: action.onPressed,
        child: action.child ?? const Text('OK'),
      );
    }
    
    // Default fallback - create a simple OK button
    return PushButton(
      controlSize: ControlSize.large,
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('OK'),
    );
  }

  /// Shows the dialog
  static Future<void> show({
    required BuildContext context,
    String? title,
    String? content,
    required List<Widget> actions,
  }) async {
    if (Platform.isWindows) {
      await fluent.showDialog(
        context: context,
        builder: (ctx) => DynamicAlertDialog(title: title, content: content, actions: actions),
      );
    } else {
      await showDialog(
        context: context,
        builder: (ctx) => DynamicAlertDialog(title: title, content: content, actions: actions),
      );
    }
  }
}

// Helper class to create platform-specific buttons
class DynamicAlertAction {
  /// Creates a cross-platform alert action
  static Widget create({
    required String text,
    required VoidCallback? onPressed,
    bool isDestructive = false,
    bool isDefault = false,
  }) {
    if (Platform.isIOS) {
      return CupertinoDialogAction(
        isDestructiveAction: isDestructive,
        isDefaultAction: isDefault,
        onPressed: onPressed,
        child: Text(text),
      );
    }
    
    if (Platform.isMacOS) {
      return PushButton(
        controlSize: ControlSize.large,
        onPressed: onPressed,
        child: Text(text),
      );
    }
    
    if (Platform.isWindows) {
      return fluent.FilledButton(
        onPressed: onPressed,
        child: Text(text),
      );
    }
    
    // Default to Material
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}