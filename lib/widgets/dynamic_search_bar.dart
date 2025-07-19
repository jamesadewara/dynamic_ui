import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// A cross-platform search bar that adapts to the platform
class DynamicSearchBar extends StatelessWidget {
  final String? hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? padding;

  const DynamicSearchBar({
    super.key,
    required this.onChanged,
    this.hintText,
    this.controller,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final pad = padding ?? const EdgeInsets.all(8);

    if (Platform.isIOS) {
      return Padding(
        padding: pad,
        child: CupertinoSearchTextField(
          controller: controller,
          onChanged: onChanged,
          placeholder: hintText ?? "Search",
        ),
      );
    }

    if (Platform.isMacOS) {
      return Padding(
        padding: pad,
        child: MacosSearchField(
          placeholder: hintText ?? "Search",
          controller: controller,
          onChanged: onChanged,
        ),
      );
    }

    if (Platform.isWindows) {
      return Padding(
        padding: pad,
        child: fluent.TextBox(
          controller: controller,
          onChanged: onChanged,
          placeholder: hintText ?? "Search",
          prefix: const Padding(
            padding: EdgeInsets.only(left: 6),
            child: Icon(fluent.FluentIcons.search),
          ),
        ),
      );
    }

    // Default: Material TextField
    return Padding(
      padding: pad,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: hintText ?? "Search",
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
