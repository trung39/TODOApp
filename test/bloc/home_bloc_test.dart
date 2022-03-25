import 'package:bloc_test/bloc_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:to_do_app/bloc/home_bloc/home_bloc.dart';
import 'package:to_do_app/data/data_provider.dart';
import 'package:to_do_app/data/submission_status.dart';

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

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

  group("HomeBloc", () {

    DataProvider? dataProvider;
    setupDataProvider() async {
      if (dataProvider == null) {
        Database testDatabase = await getTestDatabase();
        SqfliteTestData testData = SqfliteTestData(
            testDatabase: testDatabase, testTableName: _testTableName);
        dataProvider = DataProvider(testData: testData);
      }
    }

    blocTest<HomeBloc, HomeState>(
        "Expected [] on init bloc ",
        setUp: () async {
          await setupDataProvider();
        },
        build: () => HomeBloc(dataProvider!),
        expect: () => []
    );

    blocTest<HomeBloc, HomeState>(
        "ChangePageEvent test",
        setUp: () async {
          await setupDataProvider();
        },
        build: () => HomeBloc(dataProvider!),
        seed: () => const HomeState(currentPage: 0, status: InitialStatus()) ,
        act: (bloc) => bloc.add(const ChangePageEvent(pageNumber: 1)),
        expect: () => [const HomeState(currentPage: 1, status: InitialStatus())]
    );

    blocTest<HomeBloc, HomeState>(
        "BottomButtonClickEvent test",
        setUp: () async {
          await setupDataProvider();
        },
        build: () => HomeBloc(dataProvider!),
        seed: () => const HomeState(currentPage: 0, status: InitialStatus()) ,
        act: (bloc) => bloc.add(const BottomButtonClickEvent(pageNumber: 2)),
        expect: () => [const HomeState(currentPage: 2, status: InitialStatus())],
        errors: () => [isA<AssertionError>()], // Error when ScrollController is not attached to any scroll views
    );

    String toDoTestContent = "TestContent";
    blocTest<HomeBloc, HomeState>(
        "AddToDoEvent test",
        setUp: () async {
          await setupDataProvider();
        },
        build: () => HomeBloc(dataProvider!),
        seed: () => const HomeState(currentPage: 0, status: InitialStatus()) ,
        act: (bloc) => bloc.add(AddToDoEvent(content: toDoTestContent)),
        skip: 1, // Skip Submitting state
        wait: const Duration(milliseconds: 1000),
        expect: () => [const HomeState(currentPage: 0, status: SubmissionSuccess())]
    );
  },);
}