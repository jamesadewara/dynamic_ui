import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

class DynamicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;

  const DynamicAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        middle: title,
        leading: leading,
        trailing: actions != null && actions!.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              )
            : null,
        backgroundColor: backgroundColor,
      );
    }

    if (Platform.isMacOS) {
      // Convert actions to ToolbarItems if needed
      final toolbarItems = _convertActionsToToolbarItems(actions);
      
      return ToolBar(
        title: title,
        leading: leading,
        centerTitle: centerTitle,
        decoration: BoxDecoration(
          color: backgroundColor ?? MacosTheme.of(context).canvasColor,
        ),
        actions: toolbarItems.cast<ToolbarItem>(), // Cast to correct type
      );
    }

    if (Platform.isWindows) {
      // For Windows, we'll create a simple app bar-like container
      // since NavigationAppBar requires NavigationView wrapper
      return Container(
        height: preferredSize.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor ?? fluent.FluentTheme.of(context).navigationPaneTheme.backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: fluent.FluentTheme.of(context).resources.dividerStrokeColorDefault,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: leading!,
              ),
            ],
            if (title != null) ...[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: leading != null ? 16.0 : 24.0),
                  child: Align(
                    alignment: centerTitle ? Alignment.center : Alignment.centerLeft,
                    child: DefaultTextStyle(
                      style: fluent.FluentTheme.of(context).typography.bodyLarge ?? 
                             const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      child: title!,
                    ),
                  ),
                ),
              ),
            ] else ...[
              const Spacer(),
            ],
            if (actions != null && actions!.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                ),
              ),
            ],
          ],
        ),
      );
    }

    // Default to Material
    return AppBar(
      title: title,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      elevation: elevation,
    );
  }

  /// Converts generic actions to ToolbarItems for macOS
  List<Diagnosticable> _convertActionsToToolbarItems(List<Widget>? actions) {
    if (actions == null || actions.isEmpty) return [];
    
    return actions.map((action) {
      // If it's already a ToolbarItem, return it
      if (action is ToolbarItem) {
        return action;
      }
      
      // Convert IconButton to ToolBarIconButton
      if (action is IconButton) {
        return ToolBarIconButton(
          label: action.tooltip ?? '',
          icon: action.icon,
          onPressed: action.onPressed,
          showLabel: false,
        );
      }
      
      // Convert other buttons to ToolBarIconButton
      if (action is TextButton) {
        return ToolBarIconButton(
          label: 'Action',
          icon: const MacosIcon(CupertinoIcons.ellipsis),
          onPressed: action.onPressed,
          showLabel: false,
        );
      }
      
      // For other widgets, wrap in a ToolBarSpacer or create a custom item
      return const ToolBarSpacer();
    }).toList();
  }

  @override
  Size get preferredSize {
    if (Platform.isWindows) return const Size.fromHeight(48);
    if (Platform.isMacOS) return const Size.fromHeight(50);
    if (Platform.isIOS) return const Size.fromHeight(44);
    return const Size.fromHeight(kToolbarHeight);
  }
}