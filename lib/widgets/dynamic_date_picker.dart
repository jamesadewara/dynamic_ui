import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// Shows a platform-adaptive date picker
class DynamicDatePicker {
  static Future<DateTime?> show({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final DateTime now = DateTime.now();
    final DateTime defaultInitial = initialDate ?? now;
    final DateTime defaultFirst = firstDate ?? DateTime(now.year - 100);
    final DateTime defaultLast = lastDate ?? DateTime(now.year + 100);

    if (Platform.isIOS) {
      DateTime selected = defaultInitial;
      return await showCupertinoModalPopup<DateTime>(
        context: context,
        builder: (_) => Container(
          height: 250,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: selected,
                  mode: CupertinoDatePickerMode.date,
                  minimumDate: defaultFirst,
                  maximumDate: defaultLast,
                  onDateTimeChanged: (value) => selected = value,
                ),
              ),
              CupertinoButton(
                child: const Text('Done'),
                onPressed: () => Navigator.of(context).pop(selected),
              ),
            ],
          ),
        ),
      );
    }

    if (Platform.isMacOS) {
      DateTime selected = defaultInitial;
      return await showMacosSheet<DateTime>(
        context: context,
        builder: (_) => MacosSheet(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MacosDatePicker(
                  initialDate: defaultInitial,
                  onDateChanged: (val) => selected = val,
                ),
                const SizedBox(height: 16),
                PushButton(
                  onPressed: () => Navigator.of(context).pop(selected),
                  controlSize: ControlSize.regular,
                  child: const Text('Select'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (Platform.isWindows) {
      DateTime selected = defaultInitial;
      return await fluent.showDialog<DateTime>(
        context: context,
        builder: (_) => fluent.ContentDialog(
          title: const Text("Pick a Date"),
          content: fluent.DatePicker(
            selected: selected,
            onChanged: (val) => selected = val,
          ),
          actions: [
            fluent.Button(
              child: const Text("Done"),
              onPressed: () => Navigator.of(context).pop(selected),
            ),
          ],
        ),
      );
    }

    // Default: Material
    return await showDatePicker(
      context: context,
      initialDate: defaultInitial,
      firstDate: defaultFirst,
      lastDate: defaultLast,
    );
  }
}
