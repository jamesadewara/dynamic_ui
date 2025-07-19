import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

class DynamicRadio<T> extends StatelessWidget {
  final T groupValue;
  final List<T> options;
  final ValueChanged<T?> onChanged;
  final String Function(T)? labelBuilder;
  final Axis direction;

  const DynamicRadio({
    super.key,
    required this.groupValue,
    required this.options,
    required this.onChanged,
    this.labelBuilder,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final labels = options.map((e) => labelBuilder?.call(e) ?? e.toString()).toList();

    if (Platform.isIOS) {
      return CupertinoSegmentedControl<T>(
        groupValue: groupValue,
        onValueChanged: onChanged,
        children: {
          for (int i = 0; i < options.length; i++)
            options[i]: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(labels[i]),
            ),
        },
      );
    }

    if (Platform.isMacOS) {
      return Flex(
        direction: direction,
        children: List.generate(
          options.length,
          (i) => Row(
            children: [
              MacosRadioButton<T>(
                value: options[i],
                groupValue: groupValue,
                onChanged: onChanged,
              ),
              const SizedBox(width: 8),
              Text(labels[i]),
            ],
          ),
        ),
      );
    }

    if (Platform.isWindows) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          options.length,
          (i) => fluent.InfoLabel(
            label: '',
            child: fluent.RadioButton(
              checked: groupValue == options[i],
              onChanged: (_) => onChanged(options[i]),
              content: Text(labels[i]),
            ),
          ),
        ),
      );
    }

    // Default to Material
    return Column(
      children: List.generate(
        options.length,
        (i) => RadioListTile<T>(
          value: options[i],
          groupValue: groupValue,
          onChanged: onChanged,
          title: Text(labels[i]),
        ),
      ),
    );
  }
}
