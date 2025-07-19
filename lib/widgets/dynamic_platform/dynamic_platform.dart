import 'package:flutter/widgets.dart';

import 'dynamic_platform_model.dart';

class DynamicPlatform extends InheritedWidget {
  final PlatformType platform;

  const DynamicPlatform({
    super.key,
    required this.platform,
    required super.child,
  });

  static PlatformType of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<DynamicPlatform>();
    return inherited?.platform ?? PlatformType.auto;
  }

  @override
  bool updateShouldNotify(DynamicPlatform oldWidget) => platform != oldWidget.platform;
}
