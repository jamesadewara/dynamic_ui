import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

class DynamicSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
  }) {
    if (Platform.isIOS) {
      final overlay = Overlay.of(context);
      final overlayEntry = OverlayEntry(
        builder: (ctx) => Positioned(
          bottom: 50,
          left: 20,
          right: 20,
          child: CupertinoPopupSurface(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: backgroundColor ?? CupertinoColors.systemGrey.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null)
                    Icon(icon, color: textColor ?? CupertinoColors.white),
                  if (icon != null) const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: textColor ?? CupertinoColors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      overlay.insert(overlayEntry);
      Future.delayed(duration, () => overlayEntry.remove());
    }

    else if (Platform.isMacOS) {
      showMacosAlertDialog(
        context: context,
        builder: (_) => MacosAlertDialog(
          title: const Text(""),
          message: Text(message),
          primaryButton: PushButton(
            controlSize: ControlSize.small,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ),
      );
    }

    else if (Platform.isWindows) {
      fluent.showDialog(
        context: context,
        builder: (_) => fluent.ContentDialog(
          content: fluent.InfoBar(
            title: const Text("Notice"),
            content: Text(message),
            severity: fluent.InfoBarSeverity.informational,
          ),
          actions: [
            fluent.Button(
              child: const Text("Dismiss"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }

    else {
      // Default: Material Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              if (icon != null) Icon(icon, color: textColor ?? Colors.white),
              if (icon != null) const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: textColor ?? Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor ?? Colors.black87,
          duration: duration,
        ),
      );
    }
  }
}
