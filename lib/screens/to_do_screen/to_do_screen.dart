import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/data/model/to_do.dart';
import 'package:to_do_app/data/submission_status.dart';
import 'package:to_do_app/screens/to_do_screen/bloc/to_do_bloc.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ToDoScreenState();

}

class _ToDoScreenState extends State<ToDoScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoBloc, ToDoState>(
      listener: (context, state) {

      },
      builder: (context, state) => _buildToDoList(context, state),
    );
  }

  Widget _buildToDoList(BuildContext context, ToDoState state) {
    if (state.status is Submitting) {
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
                onTap: (){},
                title: Text(toDo.content ?? "", style: TextStyle(fontSize: 18),),
                trailing: Checkbox(
                  value: toDo.isCompleted,
                  onChanged: (completed) {
                    if (completed == null) {
                      return;
                    }
                    context.read<ToDoBloc>().add(MarkToDoEvent(toDo, completed));
                  }
                ),
              ),
            );
          },
          itemCount: state.todos!.length,
        ),
      ),
    );
  }

}
