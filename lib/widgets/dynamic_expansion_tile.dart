import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

class DynamicExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final Widget? leading;
  final bool initiallyExpanded;

  const DynamicExpansionTile({
    super.key,
    required this.title,
    required this.children,
    this.leading,
    this.initiallyExpanded = false,
  });

  @override
  State<DynamicExpansionTile> createState() => _DynamicExpansionTileState();
}

class _DynamicExpansionTileState extends State<DynamicExpansionTile> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 8),
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.leading != null) widget.leading!,
                Text(widget.title, style: const TextStyle(fontSize: 18)),
                Icon(_isExpanded
                    ? CupertinoIcons.chevron_up
                    : CupertinoIcons.chevron_down),
              ],
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(children: widget.children),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      );
    }

    if (Platform.isMacOS) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              children: [
                if (widget.leading != null) widget.leading!,
                Text(widget.title,
                    style: MacosTheme.of(context).typography.headline),
                const Spacer(),
                Icon(
                  _isExpanded
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(children: widget.children),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      );
    }

    if (Platform.isWindows) {
      return fluent.Expander(
        header: Text(widget.title),
        initiallyExpanded: widget.initiallyExpanded,
        leading: widget.leading,
        content: Column(children: widget.children),
      );
    }

    // Default: Material
    return ExpansionTile(
      title: Text(widget.title),
      leading: widget.leading,
      initiallyExpanded: widget.initiallyExpanded,
      children: widget.children,
    );
  }
}
