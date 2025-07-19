import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// A platform-adaptive tooltip that wraps any widget
class DynamicTooltip extends StatelessWidget {
  final Widget child;
  final String message;
  final EdgeInsetsGeometry padding;
  final Duration showDuration;

  const DynamicTooltip({
    super.key,
    required this.child,
    required this.message,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.showDuration = const Duration(seconds: 2),
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      // Simulate Cupertino Tooltip with long press and show dialog
      return GestureDetector(
        onLongPress: () {
          showCupertinoDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  child: const Text("OK"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        },
        child: child,
      );
    }

    if (Platform.isMacOS) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (e) => _showOverlay(context),
        onExit: (e) => _removeOverlay(),
        child: child,
      );
    }

    if (Platform.isWindows) {
      return fluent.Tooltip(
        message: message,
        useMousePosition: true,
        child: child,
      );
    }

    // Default: Material Tooltip
    return Tooltip(
      message: message,
      padding: padding,
      showDuration: showDuration,
      child: child,
    );
  }

  static final _overlayKey = GlobalKey();
  static OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    final renderBox = _overlayKey.currentContext?.findRenderObject() as RenderBox?;
    final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy - 30,
        left: offset.dx + 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
