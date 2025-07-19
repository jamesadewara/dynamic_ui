# Dynamic UI

Dynamic UI is a Flutter plugin that provides adaptive UI components based on the platform your app runs on — Android, iOS, Windows, macOS, Linux, or Web — using a unified API. Build consistent, scalable, platform-native UIs with minimal effort and no redundancy.

## 🔥 Features
- One API for all platforms
- Detects platform at runtime
- Native look & feel for each OS
- Fully customizable
- Works on mobile, desktop, and web

## 🚀 Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:dynamic_ui/widgets/dynamic_button.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic UI Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Dynamic UI')),
        body: const Center(
          child: DynamicButton(label: "Click Me"),
        ),
      ),
    );
  }
}
````

For advanced usage, documentation, and platform guides, visit:
👉 **[Official Website](https://dynamicui.dev)**

🔗 Connect with the author: [James Adewara on LinkedIn](https://www.linkedin.com/in/james-adewara-b0b955290)

## 🧹 Supported Components

* `DynamicButton`
* `DynamicScrollableSheet`
* `DynamicDateTimePickerCombo`
* `DynamicAppLauncherIcon`
* `DynamicTouchFeedback`
* `DynamicClipper`
* `DynamicFloatingPanel`
* `DynamicMultiSelect`
* `DynamicAutocomplete`
* `DynamicPlatform` (context override)
* `DynamicApp` (platform-aware root widget)
* `DynamicTheme`

## 📦 Installation

```bash
flutter pub add dynamic_ui
```

## 🤝 Contributions

Contributions are welcome! Please read the [CONTRIBUTING.md](CONTRIBUTING.md) before submitting.

## 📝 License

[MIT](LICENSE)


# 🗄 Folder Scaffold

```plaintext
dynamic_ui/
├── lib/
│   ├── dynamic_ui.dart
│   ├── theme/
│   │   └── dynamic_theme.dart
│   ├── widgets/
│   │   ├── dynamic_app.dart
│   │   ├── dynamic_button.dart
│   │   ├── dynamic_platform.dart
│   │   ├── dynamic_scrollable_sheet.dart
│   │   ├── dynamic_datetime_picker_combo.dart
│   │   ├── dynamic_app_launcher_icon.dart
│   │   ├── dynamic_touch_feedback.dart
│   │   ├── dynamic_clipper.dart
│   │   ├── dynamic_floating_panel.dart
│   │   ├── dynamic_multi_select.dart
│   │   ├── dynamic_autocomplete.dart
│   │   └── (future components)
├── example/
│   ├── lib/
│   │   └── main.dart
│   └── pubspec.yaml
├── test/
│   ├── dynamic_button_test.dart
│   ├── dynamic_app_test.dart
├── pubspec.yaml
├── README.md
├── CONTRIBUTING.md
├── CHANGELOG.md
├── LICENSE
└── .gitignore
```