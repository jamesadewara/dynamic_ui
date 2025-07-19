import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:macos_ui/macos_ui.dart';
import 'dart:io' show Platform;

class DynamicScaffold extends StatelessWidget {
  final Widget? appBar;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? navigationRail;
  final Widget? sidebar;
  final Widget? title;
  final Widget? actions;

  const DynamicScaffold({
    super.key,
    this.appBar,
    this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.drawer,
    this.navigationRail,
    this.sidebar,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: appBar is CupertinoNavigationBar ? appBar as CupertinoNavigationBar : null,
        child: body ?? Container(),
      );
    }

    if (Platform.isMacOS) {
      return MacosWindow(
        child: MacosScaffold(
          toolBar: appBar is ToolBar ? appBar as ToolBar : null,
          children: [
            ContentArea(
              builder: (context, scrollController) => body ?? Container(),
            )
          ],
        ),
      );
    }

    if (Platform.isWindows) {
      return fluent.NavigationView(
        appBar: appBar is fluent.NavigationAppBar ? appBar as fluent.NavigationAppBar : null,
        content: body ?? const fluent.SizedBox.shrink(),
      );
    }

    // Default to Material Scaffold (Android, Linux, Fuchsia, Web, etc.)
    return Scaffold(
      appBar: appBar is PreferredSizeWidget ? appBar as PreferredSizeWidget : null,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
    );
  }
}
