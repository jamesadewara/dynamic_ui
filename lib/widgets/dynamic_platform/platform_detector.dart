import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';

import 'dynamic_platform.dart';
import 'dynamic_platform_model.dart';

class PlatformDetector {
  static PlatformType platform(BuildContext context) {
    final override = DynamicPlatform.of(context);
    if (override != PlatformType.auto) return override;

    if (kIsWeb) return PlatformType.web;
    if (Platform.isAndroid) return PlatformType.android;
    if (Platform.isIOS) return PlatformType.iOS;
    if (Platform.isMacOS) return PlatformType.macOS;
    if (Platform.isWindows) return PlatformType.windows;
    if (Platform.isLinux) return PlatformType.linux;
    if (Platform.isFuchsia) return PlatformType.fuchsia;

    return PlatformType.auto; // fallback
  }

  static bool isIOS(BuildContext context) => platform(context) == PlatformType.iOS;
  static bool isAndroid(BuildContext context) => platform(context) == PlatformType.android;
  static bool isWeb(BuildContext context) => platform(context) == PlatformType.web;
  static bool isWindows(BuildContext context) => platform(context) == PlatformType.windows;
}
