import 'package:flutter/material.dart';
import 'package:dynamic_ui/dynamic_ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DynamicApp(
      title: 'Dynamic UI Example',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic UI Example')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DynamicButton(child: Text("Press Me")),
          ],
        ),
      ),
    );
  }
}
