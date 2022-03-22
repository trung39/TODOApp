part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

/// Event to add new Todo
class AddToDoEvent extends HomeEvent {
  final String? content;

  const AddToDoEvent({required this.content});
}

/// Event trigger when user swipe between todo pages
class ChangePageEvent extends HomeEvent {
  final int pageNumber;

  const ChangePageEvent({required this.pageNumber});
}

/// Event trigger when click on bottom app bar buttons
class BottomButtonClickEvent extends HomeEvent {
  final int pageNumber;

  const BottomButtonClickEvent({required this.pageNumber});
}