import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/data/model/to_do.dart';
import 'package:to_do_app/data/submission_status.dart';
import 'package:to_do_app/bloc/to_do_bloc/to_do_bloc.dart';
import 'package:to_do_app/ui_helper.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ToDoScreenState();

}

class _ToDoScreenState extends State<ToDoScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoBloc, ToDoState>(
      listenWhen: (previous, current) {
        if (current.toDoInteractStatus is Submitting ||
            (previous.toDoInteractStatus is Submitting
                && (current.toDoInteractStatus is SubmissionFailed || current.toDoInteractStatus is SubmissionSuccess))) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state.toDoInteractStatus is Submitting) {
          showProgressDialog(context);
        } else if (state.toDoInteractStatus is SubmissionFailed) {
          Navigator.pop(context);
          showAlertDialog(context, state.toDoInteractStatus.message);
        } else if (state.toDoInteractStatus is SubmissionSuccess) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) => _buildToDoList(context, state),
    );
  }

  Widget _buildToDoList(BuildContext context, ToDoState state) {
    if (state.getToDosStatus is Submitting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.todos == null) {
      return Container();
    }

    return Material(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ListView.builder(
          itemBuilder: (context, index) {
            ToDo toDo = state.todos![index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                tileColor: Colors.white,
                title: Text(toDo.content ?? "", style: TextStyle(fontSize: 17),),
                trailing: Checkbox(
                    value: toDo.isCompleted,
                    onChanged: (completed) {
                      if (completed == null) {
                        return;
                      }
                      context.read<ToDoBloc>().add(MarkToDoEvent(toDo, completed));
                    }
                ),
                onTap: (){},
                onLongPress: () {
                  showConfirmDialog(context,
                      title: "Delete this Todo?",
                      onSubmit: () {
                        context.read<ToDoBloc>().add(DeleteToDoEvent(toDo.id ?? ""));
                      }
                  );
                },
              ),
            );
          },
          itemCount: state.todos!.length,
        ),
      ),
    );
  }

}
