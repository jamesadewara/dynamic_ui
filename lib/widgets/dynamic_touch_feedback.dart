import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// Cross-platform touch/click feedback widget
class DynamicTouchFeedback extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const DynamicTouchFeedback({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      // Cupertino tap opacity feedback
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: _CupertinoFeedback(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          child: child,
        ),
      );
    }

    if (Platform.isWindows) {
      // Fluent hover effect with custom feedback
      return _FluentFeedback(
        onTap: onTap,
        borderRadius: borderRadius,
        child: child,
      );
    }

    // Default Material ripple effect
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: child,
      ),
    );
  }
}

class _CupertinoFeedback extends StatefulWidget {
  final Widget child;
  final BorderRadius borderRadius;

  const _CupertinoFeedback({
    super.key,
    required this.child,
    required this.borderRadius,
  });

  @override
  State<_CupertinoFeedback> createState() => _CupertinoFeedbackState();
}

class _CupertinoFeedbackState extends State<_CupertinoFeedback> with SingleTickerProviderStateMixin {
  double _opacity = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _opacity = 0.5);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _opacity = 1.0);
  }

  void _onTapCancel() {
    setState(() => _opacity = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: _opacity,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: widget.child,
        ),
      ),
    );
  }
}

class _FluentFeedback extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const _FluentFeedback({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
  });

  @override
  State<_FluentFeedback> createState() => _FluentFeedbackState();
}

class _FluentFeedbackState extends State<_FluentFeedback> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  void _onEnter(PointerEvent event) {
    setState(() => _isHovered = true);
  }

  void _onExit(PointerEvent event) {
    setState(() => _isHovered = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = fluent.FluentTheme.of(context);
    
    Color backgroundColor = Colors.transparent;
    if (_isPressed) {
      backgroundColor = theme.resources.subtleFillColorTertiary;
    } else if (_isHovered) {
      backgroundColor = theme.resources.subtleFillColorSecondary;
    }

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// Helper class for creating consistent touch feedback across platforms
class DynamicTouchFeedbackHelper {
  /// Creates a button-like touch feedback widget
  static Widget button({
    required Widget child,
    required VoidCallback? onTap,
    BorderRadius? borderRadius,
  }) {
    return DynamicTouchFeedback(
      onTap: onTap,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: child,
    );
  }

  /// Creates a list item touch feedback widget
  static Widget listItem({
    required Widget child,
    required VoidCallback? onTap,
  }) {
    BorderRadius? borderRadius;
    if (Platform.isIOS || Platform.isMacOS) {
      borderRadius = BorderRadius.circular(8);
    } else if (Platform.isWindows) {
      borderRadius = BorderRadius.circular(4);
    }

    return DynamicTouchFeedback(
      onTap: onTap,
      borderRadius: borderRadius,
      child: child,
    );
  }

  /// Creates a card touch feedback widget
  static Widget card({
    required Widget child,
    required VoidCallback? onTap,
  }) {
    BorderRadius? borderRadius;
    if (Platform.isIOS || Platform.isMacOS) {
      borderRadius = BorderRadius.circular(12);
    } else if (Platform.isWindows) {
      borderRadius = BorderRadius.circular(8);
    } else {
      borderRadius = BorderRadius.circular(8);
    }

    return DynamicTouchFeedback(
      onTap: onTap,
      borderRadius: borderRadius,
      child: child,
    );
  }
}