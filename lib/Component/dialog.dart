import 'package:flutter/material.dart';


class AlertComponent {
  AlertDialog CreateAlertDialog(BuildContext context, String message){
    return AlertDialog(
      title: const Text('Insert Status'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('${message}'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}