import 'package:flutter/material.dart';
import 'dart:io' show Platform;

/// A platform adaptive launcher icon widget
class DynamicAppLauncherIcon extends StatelessWidget {
  final double size;
  final String assetPath;
  final String semanticLabel;

  const DynamicAppLauncherIcon({
    super.key,
    required this.assetPath,
    this.size = 64,
    this.semanticLabel = 'App Launcher Icon',
  });

  @override
  Widget build(BuildContext context) {
    final Widget image = Image.asset(
      assetPath,
      width: size,
      height: size,
      semanticLabel: semanticLabel,
      fit: BoxFit.contain,
    );

    if (Platform.isIOS || Platform.isMacOS) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.2),
        child: image,
      );
    }

    if (Platform.isWindows) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: image,
      );
    }

    // Android/Linux (Material) style - rounded rectangle
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: image,
    );
  }
}
