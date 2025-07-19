import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

class DynamicDrawerItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  DynamicDrawerItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

class DynamicDrawer extends StatelessWidget {
  final List<DynamicDrawerItem> items;
  final String? title;

  const DynamicDrawer({
    super.key,
    required this.items,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: title != null
            ? CupertinoNavigationBar(middle: Text(title!))
            : null,
        child: SafeArea(
          child: ListView(
            children: items
                .map((item) => CupertinoButton(
                      onPressed: item.onTap,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(item.icon, color: CupertinoColors.activeBlue),
                          const SizedBox(width: 12),
                          Text(item.label),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      );
    }

    if (Platform.isMacOS) {
      return Sidebar(
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          children: items
              .map(
                (item) => SidebarItem(
                  leading: MacosIcon(item.icon),
                  label: Text(item.label),
                  shape: item.onTap,
                ),
              )
              .toList(),
        ),
        minWidth: 200,
      );
    }

    if (Platform.isWindows) {
      return fluent.NavigationView(
        pane: fluent.NavigationPane(
          displayMode: fluent.PaneDisplayMode.auto,
          items: items
              .map(
                (item) => fluent.PaneItem(
                  icon: Icon(item.icon),
                  title: Text(item.label),
                  onTap: item.onTap, body: null,
                ),
              )
              .toList(),
        ),
        content: const SizedBox(), // Placeholder for routed content
      );
    }

    // Default Material Drawer
    return Drawer(
      child: ListView(
        children: [
          if (title != null)
            DrawerHeader(child: Text(title!, style: const TextStyle(fontSize: 18))),
          ...items.map((item) => ListTile(
                leading: Icon(item.icon),
                title: Text(item.label),
                onTap: item.onTap,
              )),
        ],
      ),
    );
  }
}
