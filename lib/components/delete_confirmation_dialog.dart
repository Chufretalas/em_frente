import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final String action1;
  final String action2;

  DeleteConfirmationDialog({
    required this.title,
    required this.description,
    this.action1 = "Cancel",
    this.action2 = "Confirm",
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(action1)),
        TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(action2)),
      ],
    );
  }
}
