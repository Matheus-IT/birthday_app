import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String content, {int durationSeconds = 4}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      duration: Duration(seconds: durationSeconds),
    ),
  );
}
