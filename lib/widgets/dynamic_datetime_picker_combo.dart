import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

/// A combined cross-platform date and time picker widget
class DynamicDateTimePickerCombo extends StatefulWidget {
  final DateTime? initialDateTime;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime>? onDateTimeChanged;

  const DynamicDateTimePickerCombo({
    super.key,
    this.initialDateTime,
    required this.firstDate,
    required this.lastDate,
    this.onDateTimeChanged,
  });

  @override
  State<DynamicDateTimePickerCombo> createState() => _DynamicDateTimePickerComboState();
}

class _DynamicDateTimePickerComboState extends State<DynamicDateTimePickerCombo> {
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime ?? DateTime.now();
  }

  Future<void> _pickDate() async {
    if (Platform.isIOS || Platform.isMacOS) {
      // Show Cupertino date picker modal
      await showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 250,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDateTime,
            minimumDate: widget.firstDate,
            maximumDate: widget.lastDate,
            onDateTimeChanged: (newDate) {
              setState(() {
                _selectedDateTime = DateTime(
                  newDate.year,
                  newDate.month,
                  newDate.day,
                  _selectedDateTime.hour,
                  _selectedDateTime.minute,
                );
              });
              widget.onDateTimeChanged?.call(_selectedDateTime);
            },
          ),
        ),
      );
    } else if (Platform.isWindows) {
      // Fluent UI date picker does not have a direct dialog, fallback:
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDateTime,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
      );
      if (picked != null) {
        setState(() {
          _selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            _selectedDateTime.hour,
            _selectedDateTime.minute,
          );
        });
        widget.onDateTimeChanged?.call(_selectedDateTime);
      }
    } else {
      // Android/Linux Material
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDateTime,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
      );
      if (picked != null) {
        setState(() {
          _selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            _selectedDateTime.hour,
            _selectedDateTime.minute,
          );
        });
        widget.onDateTimeChanged?.call(_selectedDateTime);
      }
    }
  }

  Future<void> _pickTime() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 250,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            initialTimerDuration: Duration(
              hours: _selectedDateTime.hour,
              minutes: _selectedDateTime.minute,
            ),
            onTimerDurationChanged: (duration) {
              setState(() {
                _selectedDateTime = DateTime(
                  _selectedDateTime.year,
                  _selectedDateTime.month,
                  _selectedDateTime.day,
                  duration.inHours,
                  duration.inMinutes % 60,
                );
              });
              widget.onDateTimeChanged?.call(_selectedDateTime);
            },
          ),
        ),
      );
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (timeOfDay != null) {
        setState(() {
          _selectedDateTime = DateTime(
            _selectedDateTime.year,
            _selectedDateTime.month,
            _selectedDateTime.day,
            timeOfDay.hour,
            timeOfDay.minute,
          );
        });
        widget.onDateTimeChanged?.call(_selectedDateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = "${_selectedDateTime.toLocal()}".split(' ')[0];
    final timeText = TimeOfDay.fromDateTime(_selectedDateTime).format(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: _pickDate,
          child: Text("Date: $dateText"),
        ),
        TextButton(
          onPressed: _pickTime,
          child: Text("Time: $timeText"),
        ),
      ],
    );
  }
}
