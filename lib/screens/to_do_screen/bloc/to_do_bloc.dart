import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:to_do_app/data/data_provider.dart';
import 'package:to_do_app/data/model/to_do.dart';
import 'package:to_do_app/data/submission_status.dart';
import 'package:to_do_app/screens/to_do_screen/to_do_screen.dart';

part 'to_do_event.dart';
part 'to_do_state.dart';

class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  ToDoViewType viewType;
  DataProvider dataProvider = DataProvider();
  ToDoBloc(this.viewType) : super(ToDoState(viewType: viewType)) {

    on<LoadToDosEvent>((event, emit) async {
      emit(state.copyWith(status: Submitting()));
      late List<ToDo> toDoList;
      switch (viewType) {
        case ToDoViewType.all:
          toDoList = await dataProvider.getAllToDos();
          break;
        case ToDoViewType.incomplete:
          toDoList = await dataProvider.getIncompleteToDos();
          break;
        case ToDoViewType.complete:
          toDoList = await dataProvider.getCompletedToDos();
          break;
      }

      emit(state.copyWith(todos: toDoList, status: SubmissionSuccess()));
    });

    on<MarkToDoEvent>((event, emit) async {
      if (event.toDo.isCompleted == event.isCompleted) {
        return;
      }

      ToDo toDo = event.toDo;
      await dataProvider.updateToDo(toDo..isCompleted = event.isCompleted);
      add(LoadToDosEvent());
    });
  }
}
