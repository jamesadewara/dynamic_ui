import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// Cross-platform multi-select widget
class DynamicMultiSelect<T> extends StatefulWidget {
  final List<T> items;
  final List<T> selectedItems;
  final String Function(T) itemLabel;
  final ValueChanged<List<T>> onSelectionChanged;
  final String title;

  const DynamicMultiSelect({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.itemLabel,
    required this.onSelectionChanged,
    this.title = "Select Items",
  });

  @override
  State<DynamicMultiSelect<T>> createState() => _DynamicMultiSelectState<T>();
}

class _DynamicMultiSelectState<T> extends State<DynamicMultiSelect<T>> {
  late List<T> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List<T>.from(widget.selectedItems);
  }

  void _onItemChanged(bool? checked, T item) {
    setState(() {
      if (checked == true) {
        _tempSelected.add(item);
      } else {
        _tempSelected.remove(item);
      }
    });
  }

  void _onDone() {
    widget.onSelectionChanged(_tempSelected);
    Navigator.of(context).pop();
  }

  Future<void> _showDialog() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text(widget.title),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: CupertinoScrollbar(
              child: ListView(
                children: widget.items.map((item) {
                  final isSelected = _tempSelected.contains(item);
                  return CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _onItemChanged(!isSelected, item);
                    },
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? CupertinoIcons.check_mark_circled_solid
                              : CupertinoIcons.circle,
                          color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray,
                        ),
                        const SizedBox(width: 8),
                        Text(widget.itemLabel(item)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              onPressed: _onDone,
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } else {
      // Material and Fluent UI dialog
      await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(widget.title),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: Scrollbar(
                child: ListView(
                  children: widget.items.map((item) {
                    return CheckboxListTile(
                      value: _tempSelected.contains(item),
                      title: Text(widget.itemLabel(item)),
                      onChanged: (checked) => _onItemChanged(checked, item),
                    );
                  }).toList(),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: _onDone,
                child: const Text('Done'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedLabels = widget.selectedItems.map(widget.itemLabel).join(", ");

    return OutlinedButton(
      onPressed: _showDialog,
      child: Text(selectedLabels.isEmpty ? "Select items" : selectedLabels),
    );
  }
}
