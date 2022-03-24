import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:to_do_app/data/data_provider.dart';
import 'package:to_do_app/data/model/to_do.dart';

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

  group("DataProvider Testing", () {
    // Test data
    final List<ToDo> todos = [
      ToDo(id: "id1", content: "content1", isCompleted: true),
      ToDo(id: "id2", content: "content2", isCompleted: true),
      ToDo(id: "id3", content: "content3", isCompleted: false),
      ToDo(id: "id4", content: "content4", isCompleted: false),
      ToDo(id: "id5", content: "content5", isCompleted: false),
    ];

    test('A todo is inserted into database', () async {
      // Init test data provider
      Database testDatabase = await getTestDatabase();
      SqfliteTestData testData = SqfliteTestData(
          testDatabase: testDatabase, testTableName: _testTableName);
      DataProvider dataProvider = DataProvider(testData: testData);

      // Create a ToDo
      ToDo toDo = todos[0];

      // Insert a todo
      await dataProvider.insertToDo(toDo);

      // Check content
      expect(await testDatabase.query(_testTableName), [toDo.toJson()]);

      await testDatabase.close();
    });

    test('A todo is inserted into database, then get deleted', () async {
      // Init test data provider
      Database testDatabase = await getTestDatabase();
      SqfliteTestData testData = SqfliteTestData(
          testDatabase: testDatabase, testTableName: _testTableName);
      DataProvider dataProvider = DataProvider(testData: testData);

      // Create a ToDo
      ToDo toDo = todos[0];

      // Insert a todo
      await dataProvider.insertToDo(toDo);

      // Check inserted
      expect(await testDatabase.query(_testTableName), [toDo.toJson()]);

      // Delete a todo
      await dataProvider.deleteToDo(toDo.id!);

      // Check deleted
      expect(await testDatabase.query(_testTableName), []);

      await testDatabase.close();
    });

    test('A todo is inserted into database, then get updated by another', () async {
      // Init test data provider
      Database testDatabase = await getTestDatabase();
      SqfliteTestData testData = SqfliteTestData(
          testDatabase: testDatabase, testTableName: _testTableName);
      DataProvider dataProvider = DataProvider(testData: testData);

      // Create a ToDo
      ToDo toDo = todos[0];

      // Insert a todo
      await dataProvider.insertToDo(toDo);

      // Check inserted
      expect(await testDatabase.query(_testTableName), [toDo.toJson()]);

      ToDo toDoForUpdate = todos[2];
      // Delete a todo
      await dataProvider.updateToDo(toDo, anotherToDo: toDoForUpdate);

      // Check updated
      expect(await testDatabase.query(_testTableName), [toDoForUpdate.toJson()]);

      await testDatabase.close();
    });

    test('A list of todos is inserted, and get all inserted todos', () async {
      // Init test data provider
      Database testDatabase = await getTestDatabase();
      SqfliteTestData testData = SqfliteTestData(
          testDatabase: testDatabase, testTableName: _testTableName);
      DataProvider dataProvider = DataProvider(testData: testData);

      // Insert 5 todo from list [todos]
      await dataProvider.insertToDo(todos[0]);
      await dataProvider.insertToDo(todos[1]);
      await dataProvider.insertToDo(todos[2]);
      await dataProvider.insertToDo(todos[3]);
      await dataProvider.insertToDo(todos[4]);

      // Check if todo list got from data provider is 5 todos from list [todos]
      expect(await dataProvider.getAllToDos(), todos);

      await testDatabase.close();
    });

    test('A list of todos is inserted, and get all incomplete todos in database', () async {
      // Init test data provider
      Database testDatabase = await getTestDatabase();
      SqfliteTestData testData = SqfliteTestData(
          testDatabase: testDatabase, testTableName: _testTableName);
      DataProvider dataProvider = DataProvider(testData: testData);

      // Insert 5 todo from list [todos]
      await dataProvider.insertToDo(todos[0]);
      await dataProvider.insertToDo(todos[1]);
      await dataProvider.insertToDo(todos[2]);
      await dataProvider.insertToDo(todos[3]);
      await dataProvider.insertToDo(todos[4]);

      // Get a list of incomplete todo from [todos]
      List<ToDo> incompleteTodoList = List.from(todos.where((element) => !element.isCompleted));

      // Check if todo list got from data provider is 5 todos from list [todos]
      expect(await dataProvider.getIncompleteToDos(), incompleteTodoList);

      await testDatabase.close();
    });

    test('A list of todos is inserted, and get all completed todos in database', () async {
      // Init test data provider
      Database testDatabase = await getTestDatabase();
      SqfliteTestData testData = SqfliteTestData(
          testDatabase: testDatabase, testTableName: _testTableName);
      DataProvider dataProvider = DataProvider(testData: testData);

      // Insert 5 todo from list [todos]
      await dataProvider.insertToDo(todos[0]);
      await dataProvider.insertToDo(todos[1]);
      await dataProvider.insertToDo(todos[2]);
      await dataProvider.insertToDo(todos[3]);
      await dataProvider.insertToDo(todos[4]);

      // Get a list of completed todo from [todos]
      List<ToDo> completedTodoList = List.from(todos.where((element) => element.isCompleted));

      // Check if todo list got from data provider is 5 todos from list [todos]
      expect(await dataProvider.getCompletedToDos(), completedTodoList);

      await testDatabase.close();
    });

  });


}