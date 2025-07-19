import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_ui/dynamic_ui.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('DynamicApp wraps the app correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const DynamicApp(
      title: 'Test App',
      home: Scaffold(body: Text('Dynamic Home')),
    ));

    expect(find.text('Dynamic Home'), findsOneWidget);
  });
}
