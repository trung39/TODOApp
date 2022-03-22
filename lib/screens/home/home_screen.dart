import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/data/data_provider.dart';
import 'package:to_do_app/data/model/to_do.dart';
import 'package:to_do_app/data/submission_status.dart';
import 'package:to_do_app/screens/home/bloc/home_bloc.dart';
import 'package:to_do_app/screens/to_do_screen/bloc/to_do_bloc.dart';
import 'package:to_do_app/screens/to_do_screen/to_do_screen.dart';
import 'package:to_do_app/ui_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DataProvider(),
      child: BlocProvider(
        create: (context) => HomeBloc(context.read<DataProvider>()),
        child: BlocConsumer<HomeBloc, HomeState>(
          listenWhen: (previous, current) {
            if (current.status is Submitting ||
                (previous.status is Submitting
                && (current.status is SubmissionFailed || current.status is SubmissionSuccess))) {
              return true;
            }
            return false;
          },
          listener: (context, state) {
            if (state.status is Submitting) {
              showProgressDialog(context);
            } else if (state.status is SubmissionFailed) {
              Navigator.pop(context);
              showAlertDialog(context, state.status.toString());
            } else if (state.status is SubmissionSuccess) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return _buildHomeScreen(context, state);
          },
        ),
      ),
    );
  }

  /// Build all UIs for home screen here
  Widget _buildHomeScreen(BuildContext context, HomeState state) {
    HomeBloc bloc = context.read<HomeBloc>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(bloc.titleMap[state.currentPage] ?? ""),
        ),
        body: PageView(
          onPageChanged: (value) => bloc.add(ChangePageEvent(pageNumber: value)),
          controller: bloc.pageController,
          children: [
            BlocProvider<ToDoBloc>.value(
              value: bloc.allTodoBloc..add(LoadToDosEvent()),
              child: const ToDoScreen(),
            ),
            BlocProvider<ToDoBloc>.value(
              value: bloc.incompleteTodoBloc..add(LoadToDosEvent()),
              child: const ToDoScreen(),
            ),
            BlocProvider<ToDoBloc>.value(
              value: bloc.completeTodoBloc..add(LoadToDosEvent()),
              child: const ToDoScreen(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Add todo",
          onPressed: () async {
            String? resultText = await showTextFieldDialog(context);
            context.read<HomeBloc>().add(AddToDoEvent(content: resultText));
            // showProgressDialog(context);
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'All',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.square),
              label: 'Incomplete',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check),
              label: 'Complete',
            ),
          ],
          currentIndex: state.currentPage,
          onTap: (i) =>
              context.read<HomeBloc>().add(BottomButtonClickEvent(pageNumber: i)),
        ),
      ),
    );
  }

}