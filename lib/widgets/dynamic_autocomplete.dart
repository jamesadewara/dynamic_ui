import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

/// Cross-platform autocomplete widget
class DynamicAutocomplete<T> extends StatefulWidget {
  final List<T> options;
  final String Function(T) displayStringForOption;
  final void Function(T)? onSelected;
  final InputDecoration? decoration;

  const DynamicAutocomplete({
    super.key,
    required this.options,
    required this.displayStringForOption,
    this.onSelected,
    this.decoration,
  });

  @override
  State<DynamicAutocomplete<T>> createState() => _DynamicAutocompleteState<T>();
}

class _DynamicAutocompleteState<T> extends State<DynamicAutocomplete<T>> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  List<T> _filteredOptions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    _controller.addListener(_onTextChanged);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() => _showSuggestions = false);
      }
    });
  }

  void _onTextChanged() {
    final input = _controller.text.toLowerCase();
    setState(() {
      if (input.isEmpty) {
        _filteredOptions = [];
        _showSuggestions = false;
      } else {
        _filteredOptions = widget.options
            .where((option) =>
                widget.displayStringForOption(option).toLowerCase().contains(input))
            .toList();
        _showSuggestions = _filteredOptions.isNotEmpty;
      }
    });
  }

  void _onOptionSelected(T option) {
    _controller.text = widget.displayStringForOption(option);
    widget.onSelected?.call(option);
    setState(() {
      _showSuggestions = false;
      _filteredOptions = [];
      _focusNode.unfocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildMaterialAutocomplete(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: widget.decoration ??
              const InputDecoration(labelText: 'Type to search...'),
        ),
        if (_showSuggestions)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredOptions.length,
              itemBuilder: (context, index) {
                final option = _filteredOptions[index];
                return ListTile(
                  title: Text(widget.displayStringForOption(option)),
                  onTap: () => _onOptionSelected(option),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildCupertinoAutocomplete(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoTextField(
          controller: _controller,
          focusNode: _focusNode,
          placeholder: widget.decoration?.labelText ?? 'Type to search...',
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          clearButtonMode: OverlayVisibilityMode.editing,
        ),
        if (_showSuggestions)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              border: Border.all(color: CupertinoColors.separator),
              borderRadius: BorderRadius.circular(6),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredOptions.length,
              itemBuilder: (context, index) {
                final option = _filteredOptions[index];
                return CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  onPressed: () => _onOptionSelected(option),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(widget.displayStringForOption(option)),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return _buildCupertinoAutocomplete(context);
    }
    // Material for Android, Windows, Linux, and fallback
    return _buildMaterialAutocomplete(context);
  }
}
