import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// Item model for dynamic navigation
class DynamicNavItem {
  final IconData icon;
  final String label;
  final Widget content;

  const DynamicNavItem({
    required this.icon,
    required this.label,
    required this.content,
  });
}

/// Adaptive navigation bar (bottom or side depending on platform)
class DynamicNavigationBar extends StatelessWidget {
  final List<DynamicNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final Axis orientation;

  const DynamicNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.orientation = Axis.horizontal, // fallback for layout control
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoTabBar(
        currentIndex: selectedIndex,
        onTap: onItemSelected,
        items: items
            .map((item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.label,
                ))
            .toList(),
      );
    }

    if (Platform.isMacOS) {
      return MacosSidebar(
        minWidth: 200,
        builder: (context, controller) {
          return SidebarItems(
            currentIndex: selectedIndex,
            onChanged: onItemSelected,
            items: items
                .map((item) => SidebarItem(
                      leading: MacosIcon(item.icon),
                      label: Text(item.label),
                    ))
                .toList(),
          );
        },
      );
    }

    if (Platform.isWindows) {
      return fluent.NavigationView(
        pane: fluent.NavigationPane(
          selected: selectedIndex,
          onChanged: onItemSelected,
          displayMode: fluent.PaneDisplayMode.bottom,
          items: items
              .map((item) => fluent.PaneItem(
                    icon: Icon(item.icon),
                    title: Text(item.label),
                  ))
              .toList(),
        ),
        content: items[selectedIndex].content,
      );
    }

    // Default: Material BottomNavigationBar
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemSelected,
      items: items
          .map((item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ))
          .toList(),
    );
  }
}
