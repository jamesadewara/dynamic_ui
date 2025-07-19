import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

class DynamicDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T)? labelBuilder;
  final double? width;
  final String? hint;

  const DynamicDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.labelBuilder,
    this.width,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final itemLabels = items.map((e) => labelBuilder?.call(e) ?? e.toString()).toList();

    if (Platform.isIOS) {
      return GestureDetector(
        onTap: () async {
          int selectedIndex = items.indexOf(value);
          await showCupertinoModalPopup(
            context: context,
            builder: (_) => SizedBox(
              height: 250,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: selectedIndex),
                itemExtent: 40,
                onSelectedItemChanged: (index) => onChanged(items[index]),
                children: itemLabels.map((label) => Center(child: Text(label))).toList(),
              ),
            ),
          );
        },
        child: Container(
          width: width ?? double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: CupertinoColors.systemGrey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(labelBuilder?.call(value) ?? value.toString()),
        ),
      );
    }

    if (Platform.isMacOS) {
      return MacosPopupButton<T>(
        value: value,
        onChanged: onChanged,
        items: items.map((item) {
          return MacosPopupMenuItem(
            value: item,
            child: Text(labelBuilder?.call(item) ?? item.toString()),
          );
        }).toList(),
      );
    }

    if (Platform.isWindows) {
      return fluent.ComboBox<T>(
        value: value,
        onChanged: onChanged,
        items: items.map((item) {
          return fluent.ComboBoxItem(
            value: item,
            child: Text(labelBuilder?.call(item) ?? item.toString()),
          );
        }).toList(),
        placeholder: hint != null ? Text(hint!) : null,
      );
    }

    // Default to Material DropdownButton
    return DropdownButton<T>(
      value: value,
      isExpanded: true,
      onChanged: onChanged,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(labelBuilder?.call(item) ?? item.toString()),
        );
      }).toList(),
    );
  }
}
