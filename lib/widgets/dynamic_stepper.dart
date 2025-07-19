import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'dart:io' show Platform;

/// A single step in the DynamicStepper
class DynamicStep {
  final String title;
  final Widget content;
  final bool isActive;

  const DynamicStep({
    required this.title,
    required this.content,
    this.isActive = true,
  });
}

class DynamicStepper extends StatefulWidget {
  final List<DynamicStep> steps;
  final int currentStep;
  final ValueChanged<int> onStepTapped;
  final VoidCallback onStepContinue;
  final VoidCallback onStepCancel;

  const DynamicStepper({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.onStepTapped,
    required this.onStepContinue,
    required this.onStepCancel,
  });

  @override
  State<DynamicStepper> createState() => _DynamicStepperState();
}

class _DynamicStepperState extends State<DynamicStepper> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.currentStep);
  }

  @override
  void didUpdateWidget(DynamicStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _controller.jumpToPage(widget.currentStep);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.steps.length,
              (i) => GestureDetector(
                onTap: () => widget.onStepTapped(i),
                child: Container(
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.currentStep == i
                        ? CupertinoColors.activeBlue
                        : CupertinoColors.systemGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("Step ${i + 1}",
                      style: const TextStyle(color: CupertinoColors.white)),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: widget.steps.map((s) => s.content).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                onPressed: widget.onStepCancel,
                child: const Text("Back"),
              ),
              CupertinoButton.filled(
                onPressed: widget.onStepContinue,
                child: const Text("Next"),
              ),
            ],
          )
        ],
      );
    }

    if (Platform.isMacOS) {
      return Column(
        children: [
          ...List.generate(
            widget.steps.length,
            (i) => ListTile(
              title: Text(widget.steps[i].title),
              tileColor:
                  widget.currentStep == i ? MacosColors.controlBackgroundColor : null,
              onTap: () => widget.onStepTapped(i),
            ),
          ),
          const Divider(),
          Expanded(child: widget.steps[widget.currentStep].content),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PushButton(controlSize: ControlSize.large, onPressed: widget.onStepCancel, child: const Text("Back")),
              PushButton(controlSize: ControlSize.large, onPressed: widget.onStepContinue, child: const Text("Next")),
            ],
          )
        ],
      );
    }

    if (Platform.isWindows) {
      return Column(
        children: [
          fluent.PaneItemSeparator(),
          ...List.generate(
            widget.steps.length,
            (i) => fluent.ListTile.selectable(
              selected: widget.currentStep == i,
              title: Text(widget.steps[i].title),
              onPressed: () => widget.onStepTapped(i),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: widget.steps[widget.currentStep].content),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              fluent.Button(onPressed: widget.onStepCancel, child: const Text("Back")),
              fluent.FilledButton(onPressed: widget.onStepContinue, child: const Text("Next")),
            ],
          )
        ],
      );
    }

    // Default: Material Stepper
    return Stepper(
      currentStep: widget.currentStep,
      onStepTapped: widget.onStepTapped,
      onStepContinue: widget.onStepContinue,
      onStepCancel: widget.onStepCancel,
      steps: widget.steps
          .map((s) => Step(
                title: Text(s.title),
                content: s.content,
                isActive: s.isActive,
              ))
          .toList(),
    );
  }
}
