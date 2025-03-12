import 'package:flutter/material.dart';

Future<void> showNumberInputDialog({
  required BuildContext context,
  required String title,
  required String label,
  required void Function(int value) onConfirm,
}) async {
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final int? enteredValue = int.tryParse(controller.text);
              if (enteredValue != null) {
                onConfirm(enteredValue); // Pass value to the callback
                Navigator.pop(context); // Close dialog
              }
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

Future<void> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirm,
}) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog first
              onConfirm(); // Perform action
            },
            child: const Text("Confirm"),
          ),
        ],
      );
    },
  );
}
