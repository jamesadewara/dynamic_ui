import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:macos_ui/macos_ui.dart';
import 'dart:io' show Platform;

class DynamicButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final bool? disabled;
  final double? borderRadius;
  final ButtonStyle? materialStyle;

  const DynamicButton({
    super.key,
    required this.child,
    this.onPressed,
    this.padding,
    this.color,
    this.disabled,
    this.borderRadius,
    this.materialStyle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = disabled ?? onPressed == null;

    if (Platform.isIOS) {
      return CupertinoButton(
        padding: padding,
        color: color ?? CupertinoColors.activeBlue,
        disabledColor: CupertinoColors.inactiveGray,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        onPressed: isDisabled ? null : onPressed,
        child: child,
      );
    }

    if (Platform.isMacOS) {
      return PushButton(
        controlSize: ControlSize.large,
        onPressed: isDisabled ? null : onPressed,
        child: child,
      );
    }

    if (Platform.isWindows) {
      return fluent.Button(
        onPressed: isDisabled ? null : onPressed,
        style: fluent.ButtonStyle(
          padding: fluent.ButtonState.all(
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          backgroundColor: fluent.ButtonState.all(
            isDisabled
                ? fluent.FluentTheme.of(context).resources.controlAltFillColorDisabled
                : color ?? fluent.FluentTheme.of(context).accentColor,
          ),
        ),
        child: child,
      );
    }

    // Material / default
    return ElevatedButton(
      style: materialStyle ??
          ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
            ),
          ),
      onPressed: isDisabled ? null : onPressed,
      child: child,
    );
  }
}

// Helper class to create platform-specific buttons with common parameters
class DynamicButtonHelper {
  /// Creates a simple text button with platform-specific styling
  static Widget text({
    required String text,
    required VoidCallback? onPressed,
    Color? color,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    bool? disabled,
  }) {
    return DynamicButton(
      onPressed: onPressed,
      color: color,
      padding: padding,
      borderRadius: borderRadius,
      disabled: disabled,
      child: Text(text),
    );
  }

  /// Creates an icon button with platform-specific styling
  static Widget icon({
    required IconData icon,
    required VoidCallback? onPressed,
    String? label,
    Color? color,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    bool? disabled,
  }) {
    Widget child = Icon(icon);
    
    if (label != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }

    return DynamicButton(
      onPressed: onPressed,
      color: color,
      padding: padding,
      borderRadius: borderRadius,
      disabled: disabled,
      child: child,
    );
  }

  /// Creates a primary button with platform-specific styling
  static Widget primary({
    required String text,
    required VoidCallback? onPressed,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    bool? disabled,
  }) {
    Color? primaryColor;
    
    if (Platform.isIOS || Platform.isMacOS) {
      primaryColor = CupertinoColors.activeBlue;
    } else if (Platform.isWindows) {
      // Will use theme accent color in build method
      primaryColor = null;
    } else {
      primaryColor = Colors.blue;
    }

    return DynamicButton(
      onPressed: onPressed,
      color: primaryColor,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      borderRadius: borderRadius,
      disabled: disabled,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Creates a secondary button with platform-specific styling
  static Widget secondary({
    required String text,
    required VoidCallback? onPressed,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    bool? disabled,
  }) {
    Color? secondaryColor;
    
    if (Platform.isIOS || Platform.isMacOS) {
      secondaryColor = CupertinoColors.systemGrey;
    } else if (Platform.isWindows) {
      secondaryColor = Colors.grey.shade600;
    } else {
      secondaryColor = Colors.grey;
    }

    return DynamicButton(
      onPressed: onPressed,
      color: secondaryColor,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      borderRadius: borderRadius,
      disabled: disabled,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}