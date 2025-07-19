import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// Item model for DynamicPopupMenu
class DynamicPopupMenuItem<T> {
  final String label;
  final T value;
  final IconData? icon;

  const DynamicPopupMenuItem({required this.label, required this.value, this.icon});
}

/// Cross-platform popup menu
class DynamicPopupMenu<T> extends StatelessWidget {
  final List<DynamicPopupMenuItem<T>> items;
  final void Function(T value) onSelected;
  final Widget child;

  const DynamicPopupMenu({
    super.key,
    required this.items,
    required this.onSelected,
    required this.child,
  });

  void _showCupertinoActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: items.map((item) {
          return CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              onSelected(item.value);
            },
            child: Text(item.label),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDefaultAction: true,
          child: const Text("Cancel"),
        ),
      ),
    );
  }

  void _showMacosSheet(BuildContext context, Offset position) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMacosSheetPopup(
      context: context,
      builder: (_) => MacosPopupButton<T>(
        items: items.map((item) {
          return MacosPopupMenuItem<T>(
            value: item.value,
            child: Row(
              children: [
                if (item.icon != null) MacosIcon(item.icon!),
                if (item.icon != null) const SizedBox(width: 6),
                Text(item.label),
              ],
            ),
          );
        }).toList(),
        onSelected: onSelected,
        child: const SizedBox(), // Not used
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return GestureDetector(
        onTap: () => _showCupertinoActionSheet(context),
        child: child,
      );
    }

    if (Platform.isMacOS) {
      return GestureDetector(
        onTapDown: (details) => _showMacosSheet(context, details.globalPosition),
        child: child,
      );
    }

    if (Platform.isWindows) {
      return fluent.Flyout(
        content: (context) => fluent.MenuFlyout(
          items: items
              .map(
                (item) => fluent.MenuFlyoutItem(
                  leading: item.icon != null ? Icon(item.icon) : null,
                  text: Text(item.label),
                  onPressed: () => onSelected(item.value),
                ),
              )
              .toList(),
        ),
        child: child,
      );
    }

    // Default: Material PopupMenuButton
    return PopupMenuButton<T>(
      onSelected: onSelected,
      itemBuilder: (context) => items
          .map(
            (item) => PopupMenuItem<T>(
              value: item.value,
              child: Row(
                children: [
                  if (item.icon != null) Icon(item.icon, size: 18),
                  if (item.icon != null) const SizedBox(width: 6),
                  Text(item.label),
                ],
              ),
            ),
          )
          .toList(),
      child: child,
    );
  }
}
