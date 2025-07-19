import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class DynamicApp extends StatelessWidget {
  final Widget home;
  final Map<String, WidgetBuilder>? routes;
  final ThemeData? materialTheme;
  final CupertinoThemeData? cupertinoTheme;
  final fluent.FluentThemeData? fluentTheme;
  final String? title;
  final bool debugShowCheckedModeBanner;

  const DynamicApp({
    super.key,
    required this.home,
    this.routes,
    this.materialTheme,
    this.cupertinoTheme,
    this.fluentTheme,
    this.title,
    this.debugShowCheckedModeBanner = false,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoApp(
        home: home,
        routes: routes ?? const {},
        theme: cupertinoTheme ?? const CupertinoThemeData(),
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        title: title ?? '',
      );
    }

    if (Platform.isWindows) {
      // Use FluentApp for native Windows look
      return fluent.FluentApp(
        home: home,
        routes: routes ?? const {},
        theme: fluentTheme ?? fluent.FluentThemeData(),
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        title: title ?? '',
      );
    }

    // Android, Linux, others fallback to MaterialApp
    return MaterialApp(
      home: home,
      routes: routes ?? const {},
      theme: materialTheme ?? ThemeData(),
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      title: title ?? '',
    );
  }
}
