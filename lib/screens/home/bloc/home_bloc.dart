import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:to_do_app/data/data_provider.dart';
import 'package:to_do_app/data/model/to_do.dart';
import 'package:to_do_app/data/submission_status.dart';
import 'package:to_do_app/screens/to_do_screen/bloc/to_do_bloc.dart';
import 'package:to_do_app/screens/to_do_screen/to_do_screen.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  DataProvider dataProvider;
  final pageController = PageController(initialPage: 0);

  final Map<int, String> titleMap = {
    0: "All ToDos",
    1: "Incomplete ToDos",
    2: "Completed ToDos"
  };

  ToDoBloc allTodoBloc = ToDoBloc(ToDoViewType.all);
  ToDoBloc incompleteTodoBloc = ToDoBloc(ToDoViewType.incomplete);
  ToDoBloc completeTodoBloc = ToDoBloc(ToDoViewType.complete);

  HomeBloc(this.dataProvider) : super(const HomeState()) {
    on<AddToDoEvent>((event, emit) async {
      emit(state.copyWith(status: Submitting()));
      await Future.delayed(const Duration(milliseconds: 500));
      if (event.content == null || event.content!.isEmpty) {
        emit(state.copyWith(status: SubmissionFailed(message: "Empty todo content")));
        return;
      }
      // Create a todo
      ToDo toDo = ToDo(content: event.content);

      // Insert into database
      int result = await dataProvider.insertToDo(toDo);

      if (result == 0) {
        String failedMessage = "Failed to add new todo";
        addError(failedMessage, StackTrace.current);
        emit(state.copyWith(status: SubmissionFailed(message: failedMessage)));
      } else {
        // Reload current page
        reloadPage(state.currentPage);
        emit(state.copyWith(status: SubmissionSuccess()));
      }
    });

    on<ChangePageEvent>((event, emit) {
      // Emit new page number
      emit(state.copyWith(currentPage: event.pageNumber));
    });

    on<BottomButtonClickEvent>((event, emit) {
      // Emit new page number
      emit(state.copyWith(currentPage: event.pageNumber));

      // Animate page view to that page
      pageController.animateToPage(event.pageNumber,
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear);
    });

  }

  /// Reload the current todo page.
  /// Simply add an event to bloc
  ///
  reloadPage(int currentPage) {
    switch (currentPage) {
      case 0:
        allTodoBloc.add(LoadToDosEvent());
        break;
      case 1:
        incompleteTodoBloc.add(LoadToDosEvent());
        break;
      case 2:
        completeTodoBloc.add(LoadToDosEvent());
        break;
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print('$error, $stackTrace');
    }
    super.onError(error, stackTrace);
  }
}
