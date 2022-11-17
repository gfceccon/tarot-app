import 'package:flutter/material.dart';

bool loginAlert(BuildContext context, String text) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            content: Text(text),
            actions: [
              TextButton(
                  onPressed: () => {Navigator.of(context).pop()},
                  child: const Text('OK'))
            ],
          ));
  return false;
}
