part of 'to_do_bloc.dart';

class ToDoState extends Equatable {
  const ToDoState({
    required this.viewType,
    this.todos,
    this.getToDosStatus = const InitialStatus(),
    this.toDoInteractStatus = const InitialStatus(),
  });

  /// The view type of todo page
  final ToDoViewType viewType;
  /// The todo list to show to UI
  final List<ToDo>? todos;
  /// The status of action
  final SubmissionStatus getToDosStatus;
  final SubmissionStatus toDoInteractStatus;

  @override
  List<Object?> get props => [
    viewType, todos, getToDosStatus, toDoInteractStatus
  ];

  ToDoState copyWith({
    ToDoViewType? viewType,
    List<ToDo>? todos,
    SubmissionStatus? getToDosStatus,
    SubmissionStatus? toDoInteractStatus
  }) {
    return ToDoState(
      viewType: viewType ?? this.viewType,
      todos: todos ?? this.todos,
      getToDosStatus: getToDosStatus ?? this.getToDosStatus,
      toDoInteractStatus: toDoInteractStatus ?? this.toDoInteractStatus,
    );
  }
}

/// The view type of todo page
enum ToDoViewType {
  all, incomplete, complete
}