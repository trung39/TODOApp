part of 'to_do_bloc.dart';

class ToDoState extends Equatable {
  const ToDoState({
    required this.viewType,
    this.todos,
    this.status = const InitialStatus()
  });

  /// The view type of todo page
  final ToDoViewType viewType;
  /// The todo list to show to UI
  final List<ToDo>? todos;
  /// The status of action
  final SubmissionStatus status;

  @override
  List<Object?> get props => [
    viewType, todos, status
  ];

  ToDoState copyWith({
    ToDoViewType? viewType,
    List<ToDo>? todos,
    SubmissionStatus? status
  }) {
    return ToDoState(
      viewType: viewType ?? this.viewType,
      todos: todos ?? this.todos,
      status: status ?? this.status,
    );
  }
}

/// The view type of todo page
enum ToDoViewType {
  all, incomplete, complete
}