import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:to_do_app/data/data_provider.dart';
import 'package:to_do_app/data/model/to_do.dart';
import 'package:to_do_app/data/submission_status.dart';

part 'to_do_event.dart';
part 'to_do_state.dart';

class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  ToDoViewType viewType;
  DataProvider dataProvider = DataProvider();
  ToDoBloc(this.viewType) : super(ToDoState(viewType: viewType)) {

    on<LoadToDosEvent>((event, emit) async {
      emit(state.copyWith(getToDosStatus: Submitting()));
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

      emit(state.copyWith(todos: toDoList, getToDosStatus: SubmissionSuccess()));
    });

    on<MarkToDoEvent>((event, emit) async {
      emit(state.copyWith(toDoInteractStatus: Submitting()));
      if (event.toDo.isCompleted == event.isCompleted) {
        return;
      }

      ToDo toDo = event.toDo;
      int result = await dataProvider.updateToDo(toDo..isCompleted = event.isCompleted);
      await Future.delayed(const Duration(milliseconds: 500));

      if (result == 0) {
        // No update in database
        String failedMessage = "Failed to change todo status ";
        addError(failedMessage, StackTrace.current);
        emit(state.copyWith(toDoInteractStatus: SubmissionFailed(message: failedMessage)));
      } else {
        // Update successful
        emit(state.copyWith(toDoInteractStatus: SubmissionSuccess()));
        add(LoadToDosEvent());
      }
    });

    on<DeleteToDoEvent>((event, emit) async {
      emit(state.copyWith(toDoInteractStatus: Submitting()));

      int result = await dataProvider.deleteToDo(event.todoId);
      await Future.delayed(const Duration(milliseconds: 500));

      if (result == 0) {
        // No update in database
        String failedMessage = "Failed to delete todo";
        addError(failedMessage, StackTrace.current);
        emit(state.copyWith(toDoInteractStatus: SubmissionFailed(message: failedMessage)));
      } else {
        // Update successful
        emit(state.copyWith(toDoInteractStatus: SubmissionSuccess()));
        add(LoadToDosEvent());
      }
    });
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print('$error, $stackTrace');
    }
    super.onError(error, stackTrace);
  }
}
