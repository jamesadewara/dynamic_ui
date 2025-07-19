import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_ui/dynamic_ui.dart';

void main() {
  testWidgets('DynamicButton renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: DynamicButton(label: 'Test'),
      ),
    ));

    expect(find.text('Test'), findsOneWidget);
  });
}