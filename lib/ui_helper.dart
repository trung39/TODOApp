import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Future to show a dialog with text field and 2 confirm buttons
/// Return the text in the text field on pressing OK
Future<String?> showTextFieldDialog(BuildContext context) async {
  return await showDialog<String>(
      context: context,
      builder: (context) {
        TextEditingController textEditingController = TextEditingController();
        return AlertDialog(
          title: Text('Create a ToDo'),
          content: TextField(
            controller: textEditingController,
            decoration: InputDecoration(hintText: "ToDo content"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                  Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context, textEditingController.text)
            ),
          ],
        );
      });

}