import 'package:flutter/material.dart';

Future showErrorDialog(BuildContext context, {required String content, Future Function()? action}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Erro'),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Tentar novamente'),
            onPressed: () {
              Navigator.of(context).pop();
              if (action != null) {
                action();
              }
            },
          ),
        ],
      );
    },
  );
}
