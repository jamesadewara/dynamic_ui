import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

/// A cross-platform scrollable bottom sheet
class DynamicScrollableSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double initialChildSize = 0.5,
    double minChildSize = 0.25,
    double maxChildSize = 0.9,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useSafeArea = true,
  }) {
    if (Platform.isIOS || Platform.isMacOS) {
      // Cupertino-style modal bottom sheet (slide-up)
      return showCupertinoModalPopup<T>(
        context: context,
        barrierDismissible: isDismissible,
        builder: (ctx) => SafeArea(
          top: false,
          bottom: useSafeArea,
          child: FractionallySizedBox(
            heightFactor: initialChildSize,
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(ctx),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: child,
            ),
          ),
        ),
      );
    }

    // Material-style draggable scrollable bottom sheet
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: useSafeArea,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        expand: false,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).dialogBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: child,
          ),
        ),
      ),
    );
  }
}
