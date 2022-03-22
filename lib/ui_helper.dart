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
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context, textEditingController.text)
            ),
          ],
        );
      });
}

Future showConfirmDialog(BuildContext context, {String? title, Function? onSubmit}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title ?? ""),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
              if (onSubmit != null) {
                onSubmit();
              }
            }
          ),
        ],
      );
    }
  );
}

/// Show a snack bar with the given information
showSnackBar(BuildContext context, String message, {String? actionName, function, SnackBarBehavior? behavior, int? duration}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: behavior ?? SnackBarBehavior.floating,
    duration: Duration(milliseconds: duration ?? 4000),
    content: Text(
      message,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    action: SnackBarAction(
      label: actionName ?? "OK",
      onPressed: function ?? () {},
    ),
  ));
}

Future showAlertDialog(BuildContext context, String message) async {
  await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context)
            ),
          ],
        );
      });
}

Future showProgressDialog(BuildContext context) async {
  await showDialog<String>(
      context: context,
      builder: (context) {
        return const Dialog(
          child: Center(
              heightFactor: 2,
              child: CircularProgressIndicator()
          ),
        );
      });
}