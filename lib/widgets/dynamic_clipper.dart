import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

/// Cross-platform clipper with platform-specific shapes
class DynamicClipper extends StatelessWidget {
  final Widget child;
  final ClipShape shape;

  const DynamicClipper({
    super.key,
    required this.child,
    this.shape = ClipShape.roundedRectangle,
  });

  @override
  Widget build(BuildContext context) {
    switch (shape) {
      case ClipShape.circle:
        return ClipOval(child: child);
      case ClipShape.stadium:
        return ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: child,
        );
      case ClipShape.roundedRectangle:
        return ClipRRect(
          borderRadius: _defaultBorderRadius(),
          child: child,
        );
      case ClipShape.custom:
        return ClipPath(
          clipper: _CustomClipper(),
          child: child,
        );
    }
  }

  BorderRadius _defaultBorderRadius() {
    if (Platform.isIOS || Platform.isMacOS) {
      return BorderRadius.circular(16);
    }
    if (Platform.isWindows) {
      return BorderRadius.circular(8);
    }
    // Android/Linux default
    return BorderRadius.circular(12);
  }
}

enum ClipShape {
  circle,
  stadium,
  roundedRectangle,
  custom,
}

class _CustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Example custom clip: diagonal cut from top-left to bottom-right
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height * 0.7);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
