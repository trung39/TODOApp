import 'package:bloc_test/bloc_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:to_do_app/bloc/to_do_bloc/to_do_bloc.dart';
import 'package:to_do_app/data/data_provider.dart';
import 'package:to_do_app/data/model/to_do.dart';
import 'package:to_do_app/data/submission_status.dart';

class MockToDoBloc extends MockBloc<ToDoEvent, ToDoState> implements ToDoBloc {}

Future main() async {

  // Setup sqflite_common_ffi for flutter test
  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  });

  String _testTableName = "todos_test";
  Future<Database> getTestDatabase() async =>
      await openDatabase(inMemoryDatabasePath, version: 1,
          onCreate: (db, version) async {
            await db.execute(
                'CREATE TABLE $_testTableName(id TEXT PRIMARY KEY, content TEXT, is_completed INTEGER)');
          });

  const Duration timeToWait = Duration(milliseconds: 1000);
  // Test data
  final List<ToDo> todos = [
    ToDo(id: "id0", content: "content0", isCompleted: true),
    ToDo(id: "id1", content: "content1", isCompleted: true),
    ToDo(id: "id2", content: "content2", isCompleted: false),
    ToDo(id: "id3", content: "content3", isCompleted: false),
    ToDo(id: "id4", content: "content4", isCompleted: false),
  ];

  group("HomeBloc", () {

    Database? testDatabase;
    DataProvider? dataProvider;
    setupData({bool insetList = false}) async {
      if (testDatabase == null || dataProvider == null) {
        testDatabase = await getTestDatabase();
        SqfliteTestData testData = SqfliteTestData(
            testDatabase: testDatabase!, testTableName: _testTableName);
        dataProvider = DataProvider(testData: testData);
      }

      if (insetList) {
        dataProvider!.insertToDo(todos[0]);
        dataProvider!.insertToDo(todos[1]);
        dataProvider!.insertToDo(todos[2]);
        dataProvider!.insertToDo(todos[3]);
        dataProvider!.insertToDo(todos[4]);
      }
    }

    dispose() {
      if (testDatabase != null) {
        testDatabase!.close();
        testDatabase = null;
      }
      if (dataProvider != null) {
        dataProvider == null;
      }
    }

    blocTest<ToDoBloc, ToDoState>(
        "Expected [] on init bloc ",
        setUp: () async {
          await setupData();
        },
        build: () => ToDoBloc(viewType: ToDoViewType.all, dataProvider: dataProvider!),
        expect: () => [],
        tearDown: () => dispose(),
    );

    blocTest<ToDoBloc, ToDoState>(
        "Load all todos test",
        setUp: () async {
          await setupData(insetList: true);
        },
        build: () => ToDoBloc(viewType: ToDoViewType.all, dataProvider: dataProvider!),
        skip: 1,
        wait: timeToWait,
        act: (bloc) => bloc.add(LoadToDosEvent()),
        expect: () => [
            ToDoState(
                viewType: ToDoViewType.all,
                todos: todos,
                getToDosStatus: const SubmissionSuccess(),
                toDoInteractStatus: const InitialStatus())
        ],
        tearDown: () => dispose(),
    );

    blocTest<ToDoBloc, ToDoState>(
        "Load incomplete todos test",
        setUp: () async {
          await setupData(insetList: true);
        },
        build: () => ToDoBloc(viewType: ToDoViewType.incomplete, dataProvider: dataProvider!),
        skip: 1,
        wait: timeToWait,
        act: (bloc) => bloc.add(LoadToDosEvent()),
        expect: () => [
            ToDoState(
                viewType: ToDoViewType.incomplete,
                todos: List.of(todos.where((element) => !element.isCompleted)),
                getToDosStatus: const SubmissionSuccess(),
                toDoInteractStatus: const InitialStatus())
        ],
        tearDown: () => dispose(),
    );

    blocTest<ToDoBloc, ToDoState>(
        "Load complete todos test",
        setUp: () async {
          await setupData(insetList: true);
        },
        build: () => ToDoBloc(viewType: ToDoViewType.complete, dataProvider: dataProvider!),
        skip: 1,
        wait: timeToWait,
        act: (bloc) => bloc.add(LoadToDosEvent()),
        expect: () => [
            ToDoState(
                viewType: ToDoViewType.complete,
                todos: List.of(todos.where((element) => element.isCompleted)),
                getToDosStatus: const SubmissionSuccess(),
                toDoInteractStatus: const InitialStatus())
        ],
        tearDown: () => dispose(),
    );

    blocTest<ToDoBloc, ToDoState>(
        "Mark to do incomplete",
        setUp: () async {
          await setupData();
          dataProvider!.insertToDo(todos[0]); // ToDo(id: "id0", content: "content0", isCompleted: true),

        },
        build: () => ToDoBloc(viewType: ToDoViewType.all, dataProvider: dataProvider!),
        // Skipping 3 state:
          // <submitting of markEvent>,
          // <mark successful>,
          // <submitting reload todo list>
        skip: 3,
        wait: timeToWait,
        act: (bloc) => bloc.add(MarkToDoEvent(todos[0], false)),
        expect: () => [
            ToDoState(
                viewType: ToDoViewType.all,
                todos: [todos[0].copyWith(isCompleted: false)],
                getToDosStatus: const SubmissionSuccess(),
                toDoInteractStatus: const SubmissionSuccess())
        ],
        tearDown: () => dispose(),
    );

    blocTest<ToDoBloc, ToDoState>(
        "Mark to do completed",
        setUp: () async {
          await setupData();
          dataProvider!.insertToDo(todos[3]); // ToDo(id: "id3", content: "content3", isCompleted: false),

        },
        build: () => ToDoBloc(viewType: ToDoViewType.all, dataProvider: dataProvider!),
        // Skipping 3 state:
          // <Submitting of markEvent>,
          // <Mark successful>,
          // <Submitting reload todo list>
        skip: 3,
        wait: timeToWait,
        act: (bloc) => bloc.add(MarkToDoEvent(todos[3], true)),
        expect: () => [
            ToDoState(
                viewType: ToDoViewType.all,
                todos: [todos[3].copyWith(isCompleted: true)],
                getToDosStatus: const SubmissionSuccess(),
                toDoInteractStatus: const SubmissionSuccess())
        ],
        tearDown: () => dispose(),
    );

    blocTest<ToDoBloc, ToDoState>(
        "Delete todo",
        setUp: () async {
          await setupData(insetList: true);

        },
        build: () => ToDoBloc(viewType: ToDoViewType.all, dataProvider: dataProvider!),
        // Skipping 3 state:
          // <Submitting of delete event>,
          // <Delete successful>,
          // <Submitting reload todo list>
        skip: 3,
        wait: timeToWait,
        act: (bloc) => bloc.add(DeleteToDoEvent(todos[1].id!)),
        expect: () => [
            ToDoState(
                viewType: ToDoViewType.all,
                todos: List.of(todos.where((element) => element.id != todos[1].id!)),
                getToDosStatus: const SubmissionSuccess(),
                toDoInteractStatus: const SubmissionSuccess())
        ],
        tearDown: () => dispose(),
    );

  },);
}