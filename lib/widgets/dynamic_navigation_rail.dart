import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// Model for navigation items
class DynamicNavItem {
  final IconData icon;
  final String label;

  const DynamicNavItem({required this.icon, required this.label});
}

class DynamicNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final List<DynamicNavItem> destinations;
  final ValueChanged<int> onDestinationSelected;

  const DynamicNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoSegmentedControl<int>(
        groupValue: selectedIndex,
        onValueChanged: onDestinationSelected,
        children: {
          for (int i = 0; i < destinations.length; i++)
            i: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(destinations[i].label),
            ),
        },
      );
    }

    if (Platform.isMacOS) {
      return MacosSidebar(
        minWidth: 180,
        builder: (context, controller) => ListView.builder(
          controller: controller,
          itemCount: destinations.length,
          itemBuilder: (context, i) => SidebarItem(
            leading: MacosIcon(destinations[i].icon),
            label: Text(destinations[i].label),
            selected: i == selectedIndex,
            onTap: () => onDestinationSelected(i),
          ),
        ),
      );
    }

    if (Platform.isWindows) {
      return fluent.NavigationView(
        pane: fluent.NavigationPane(
          selected: selectedIndex,
          onChanged: onDestinationSelected,
          displayMode: fluent.PaneDisplayMode.compact,
          items: destinations
              .map((e) => fluent.PaneItem(
                    icon: Icon(e.icon),
                    title: Text(e.label),
                  ))
              .toList(),
        ),
        content: const SizedBox(), // Replace with actual page
      );
    }

    // Default to Material NavigationRail
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      destinations: destinations
          .map((e) => NavigationRailDestination(
                icon: Icon(e.icon),
                label: Text(e.label),
              ))
          .toList(),
    );
  }
}
