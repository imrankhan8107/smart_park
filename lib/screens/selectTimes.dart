import 'package:flutter/material.dart';

class TimeInputDialog extends StatefulWidget {
  const TimeInputDialog({super.key});

  @override
  _TimeInputDialogState createState() => _TimeInputDialogState();
}

class _TimeInputDialogState extends State<TimeInputDialog> {
  int _hours = 0;
  int _minutes = 0;

  void _setHours(String value) {
    setState(() {
      _hours = int.tryParse(value) ?? 0;
    });
  }

  void _setMinutes(String value) {
    setState(() {
      _minutes = int.tryParse(value) ?? 0;
    });
  }

  void _submit() {
    Navigator.of(context).pop(TimeOfDay(hour: _hours, minute: _minutes));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter time'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Charges for 30 mins: 100 Rs"),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Hours'),
            onChanged: _setHours,
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Minutes'),
            onChanged: _setMinutes,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: _submit,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
