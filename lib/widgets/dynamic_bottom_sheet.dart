import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// Platform-adaptive bottom sheet/modal presentation
class DynamicBottomSheet {
  static Future<void> show({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool useSafeArea = true,
    Color? backgroundColor,
  }) async {
    if (Platform.isIOS) {
      await showCupertinoModalPopup(
        context: context,
        barrierDismissible: isDismissible,
        builder: (_) => SafeArea(
          top: false,
          child: CupertinoPopupSurface(
            child: child,
          ),
        ),
      );
    } else if (Platform.isMacOS) {
      await showMacosSheet(
        context: context,
        builder: (_) => MacosSheet(
          child: child,
        ),
      );
    } else if (Platform.isWindows) {
      await fluent.showDialog(
        context: context,
        builder: (_) => fluent.ContentDialog(
          content: child,
        ),
      );
    } else {
      await showModalBottomSheet(
        context: context,
        isDismissible: isDismissible,
        useSafeArea: useSafeArea,
        backgroundColor: backgroundColor,
        builder: (_) => child,
      );
    }
  }
}
