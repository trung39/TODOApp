part of 'to_do_bloc.dart';

abstract class ToDoEvent extends Equatable {
  const ToDoEvent();

  @override
  List<Object?> get props => [];
}

class LoadToDosEvent extends ToDoEvent {}

/// Event to mark the to do incomplete or completed
class MarkToDoEvent extends ToDoEvent {
  final bool isCompleted;
  final ToDo toDo;
  const MarkToDoEvent(this.toDo, this.isCompleted);
}

