import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

/// Unified dynamic theme provider for all platforms
class DynamicTheme {
  /// Returns ThemeData or CupertinoThemeData depending on platform
  /// Use this in your MaterialApp / CupertinoApp / FluentApp theme property
  static ThemeData get materialTheme {
    if (Platform.isIOS || Platform.isMacOS) {
      // For iOS/macOS we provide a Material theme mimicking Cupertino style
      return ThemeData(
        primaryColor: CupertinoColors.activeBlue,
        scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: CupertinoColors.systemBackground,
          elevation: 0,
          iconTheme: IconThemeData(color: CupertinoColors.activeBlue),
          titleTextStyle: TextStyle(
            color: CupertinoColors.label,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: CupertinoColors.label,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          bodyMedium: TextStyle(color: CupertinoColors.label),
        ),
        colorScheme: const ColorScheme.light(
          primary: CupertinoColors.activeBlue,
          secondary: CupertinoColors.systemGrey,
          surface: CupertinoColors.systemBackground,
          onPrimary: CupertinoColors.white,
          onSurface: CupertinoColors.label,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: CupertinoColors.activeBlue,
            foregroundColor: CupertinoColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: CupertinoColors.systemGrey6,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      );
    }

    if (Platform.isWindows) {
      // Fluent UI styled Material theme approximation
      return ThemeData(
        primaryColor: const Color(0xFF0078D4),
        scaffoldBackgroundColor: const Color(0xFFF3F3F3),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF3F3F3),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF0078D4)),
          titleTextStyle: TextStyle(
            color: Color(0xFF323130),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Color(0xFF323130),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          bodyMedium: TextStyle(color: Color(0xFF323130)),
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0078D4),
          secondary: Color(0xFF605E5C),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSurface: Color(0xFF323130),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0078D4),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(color: Color(0xFFE1DFDD)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      );
    }

    // Default Material theme for Android/Linux and fallback
    return ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        elevation: 4,
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade200,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  /// For Cupertino apps, you can use this method for CupertinoThemeData
  static CupertinoThemeData get cupertinoTheme {
    return const CupertinoThemeData(
      primaryColor: CupertinoColors.activeBlue,
      scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
      textTheme: CupertinoTextThemeData(
        primaryColor: CupertinoColors.label,
        textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
      ),
    );
  }
}