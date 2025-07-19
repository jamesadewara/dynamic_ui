import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

/// A platform-adaptive floating panel widget
class DynamicFloatingPanel extends StatefulWidget {
  final Widget child;
  final double initialWidth;
  final double initialHeight;
  final bool draggable;
  final bool resizable;

  const DynamicFloatingPanel({
    super.key,
    required this.child,
    this.initialWidth = 300,
    this.initialHeight = 400,
    this.draggable = true,
    this.resizable = true,
  });

  @override
  State<DynamicFloatingPanel> createState() => _DynamicFloatingPanelState();
}

class _DynamicFloatingPanelState extends State<DynamicFloatingPanel> {
  late Offset position;
  late double width;
  late double height;

  @override
  void initState() {
    super.initState();
    position = const Offset(50, 50);
    width = widget.initialWidth;
    height = widget.initialHeight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!widget.draggable) return;
    setState(() {
      position += details.delta;
    });
  }

  void _onResize(DragUpdateDetails details) {
    if (!widget.resizable) return;
    setState(() {
      width = (width + details.delta.dx).clamp(150, 600);
      height = (height + details.delta.dy).clamp(150, 800);
    });
  }

  @override
  Widget build(BuildContext context) {
    final panel = Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: widget.child,
      ),
    );

    // On mobile, use full screen modal bottom sheet instead
    if (Platform.isAndroid || Platform.isIOS) {
      return Scaffold(
        appBar: AppBar(title: const Text("Floating Panel")),
        body: panel,
      );
    }

    // On desktop, position and allow drag/resize
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: GestureDetector(
            onPanUpdate: _onDragUpdate,
            child: Stack(
              children: [
                panel,
                // Resize handle bottom-right corner
                if (widget.resizable)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onPanUpdate: _onResize,
                      child: const SizedBox(
                        width: 20,
                        height: 20,
                        child: Icon(Icons.drag_handle, size: 18, color: Colors.grey),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
