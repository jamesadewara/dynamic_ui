import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

class DynamicTabBar extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> views;
  final Color? selectedColor;
  final Color? unselectedColor;

  const DynamicTabBar({
    super.key,
    required this.tabs,
    required this.views,
    this.selectedColor,
    this.unselectedColor,
  })  : assert(tabs.length == views.length);

  @override
  State<DynamicTabBar> createState() => _DynamicTabBarState();
}

class _DynamicTabBarState extends State<DynamicTabBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CupertinoSegmentedControl<int>(
              groupValue: _currentIndex,
              onValueChanged: (val) => setState(() => _currentIndex = val),
              children: {
                for (int i = 0; i < widget.tabs.length; i++)
                  i: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(widget.tabs[i]),
                  )
              },
            ),
          ),
          Expanded(child: widget.views[_currentIndex]),
        ],
      );
    }

    if (Platform.isMacOS) {
      return MacosTabView(
        tabs: [
          for (int i = 0; i < widget.tabs.length; i++)
            MacosTab(
              label: widget.tabs[i],
              icon: const Icon(CupertinoIcons.circle),
              builder: (_) => widget.views[i],
            ),
        ],
      );
    }

    if (Platform.isWindows) {
      return fluent.NavigationView(
        pane: fluent.NavigationPane(
          selected: _currentIndex,
          onChanged: (i) => setState(() => _currentIndex = i),
          displayMode: fluent.PaneDisplayMode.top,
          items: [
            for (int i = 0; i < widget.tabs.length; i++)
              fluent.PaneItem(
                icon: const Icon(fluent.FluentIcons.page),
                title: Text(widget.tabs[i]),
              ),
          ],
        ),
        content: widget.views[_currentIndex],
      );
    }

    // Default: Material with TabBar
    return DefaultTabController(
      length: widget.tabs.length,
      initialIndex: _currentIndex,
      child: Column(
        children: [
          TabBar(
            onTap: (index) => setState(() => _currentIndex = index),
            tabs: widget.tabs.map((t) => Tab(text: t)).toList(),
            labelColor: widget.selectedColor,
            unselectedLabelColor: widget.unselectedColor,
          ),
          Expanded(child: widget.views[_currentIndex]),
        ],
      ),
    );
  }
}
