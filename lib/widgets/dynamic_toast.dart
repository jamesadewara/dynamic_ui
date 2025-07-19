import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// A cross-platform toast message system
class DynamicToast {
  static void show(
    String message, {
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color? backgroundColor,
    Color? textColor,
    double fontSize = 14.0,
    Duration duration = const Duration(seconds: 2),
  }) {
    final bg = backgroundColor ?? _defaultBackground();
    final fg = textColor ?? Colors.white;

    if (Platform.isAndroid || Platform.isIOS) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        backgroundColor: bg,
        textColor: fg,
        fontSize: fontSize,
      );
    } else {
      _showMaterialLikeToast(
        message,
        bgColor: bg,
        textColor: fg,
        fontSize: fontSize,
        duration: duration,
      );
    }
  }

  static void _showMaterialLikeToast(
    String message, {
    required Color bgColor,
    required Color textColor,
    required double fontSize,
    required Duration duration,
  }) {
   
    // Cannot access BuildContext directly in desktop environments,
    // so fallback to debug console.
    debugPrint("[Toast]: $message");

    // You can optionally integrate `overlay_support` or similar libraries
    // for real native toasts on Windows/macOS.
  }

  static Color _defaultBackground() {
    if (Platform.isIOS) return CupertinoColors.systemGrey.withOpacity(0.9);
    if (Platform.isWindows) return fluent.Colors.grey[70];
    return Colors.black87;
  }
}
