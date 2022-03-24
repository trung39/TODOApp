import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/data/model/to_do.dart';

class DataProvider {

  final String _tableName;
  final String _id = "id";
  final String _content = "content";
  final String _isCompleted = "is_completed";

  /// The test data used for testing
  final SqfliteTestData? testData;

  /// Construct DataProvider.
  /// If [testData] is provided, this provider is used for testing with given [testData]
  DataProvider({this.testData})
      : assert(testData == null || testData.testTableName.isNotEmpty,
            "Table name should not be empty"),
        _tableName = testData?.testTableName ?? "todos";
  
  bool get isTesting => testData != null;
  Future<Database> getDatabase() async {
    if (isTesting) {
      return testData!.testDatabase;
    }
    return await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'todo_database.db'),
      // When the database is first created, create a table to store todos.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE todos($_id TEXT PRIMARY KEY, $_content TEXT, $_isCompleted INTEGER)',
        );
      },
      version: 1,
    );
  }

  /// Function to get all ToDos in database
  ///
  Future<List<ToDo>> getAllToDos() async {
    final database = await getDatabase();

    // Query the table for all The Todos.
    final List<Map<String, dynamic>> maps = await database.query(_tableName);

    return List.generate(maps.length, (i) {
      return ToDo.fromJson(maps[i]);
    });
  }

  /// Function to get all incomplete ToDos in database
  ///
  Future<List<ToDo>> getIncompleteToDos() async {
    final database = await getDatabase();

    // Query the table for all The Todos.
    final List<Map<String, dynamic>> maps = await database.query(_tableName, where: "$_isCompleted = 0");

    return List.generate(maps.length, (i) {
      return ToDo.fromJson(maps[i]);
    });
  }

  /// Function to get all completed ToDos in database
  ///
  Future<List<ToDo>> getCompletedToDos() async {
    final database = await getDatabase();

    // Query the table for all The Todos.
    final List<Map<String, dynamic>> maps = await database.query(_tableName, where: "$_isCompleted = 1");

    return List.generate(maps.length, (i) {
      return ToDo.fromJson(maps[i]);
    });
  }

  /// Function to insert a new ToDo into database, with the given [toDo]
  ///
  Future<int> insertToDo(ToDo toDo) async {
    final database = await getDatabase();

    return await database.insert(
      _tableName,
      toDo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Function to update a ToDo in database
  ///
  /// If only [toDo] is provided, [toDo] will be updated to the database
  ///
  /// if [anotherToDo] is provided, [toDo] is replaced with [anotherToDo]
  ///
  Future<int> updateToDo(ToDo toDo, {ToDo? anotherToDo}) async {
    final database = await getDatabase();

    bool isUpdateAnother = anotherToDo != null;
    Map<String, dynamic> mapToUpdate = isUpdateAnother ? anotherToDo.toJson() : toDo.toJson();
    // Update the given Todo.
    return await database.update(
      _tableName,
      mapToUpdate,
      where: '$_id = ?',
      whereArgs: [toDo.id],
    );
  }

  /// Function to delete a ToDo in database, with the given [todoId]
  /// [testDatabase] is used for testing 
  ///
  Future<int> deleteToDo(String todoId) async {
    final database = await getDatabase();

    // Remove the ToDo from the database.
    return await database.delete(
      _tableName,
      // Use a `where` clause to delete a specific ToDo.
      where: '$_id = ?',
      // Pass the ToDo's id as a whereArg to prevent SQL injection.
      whereArgs: [todoId],
    );
  }
}

class SqfliteTestData {
  Database testDatabase;
  String testTableName;

  SqfliteTestData({required this.testDatabase, required this.testTableName});
}