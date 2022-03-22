import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/data/model/to_do.dart';

class DataProvider {

  final String tableName = "todos";
  final String id = "id";
  final String content = "content";
  final String isCompleted = "is_completed";

  Future<Database> database() async => openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'todo_database.db'),
    // When the database is first created, create a table to store todos.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE todos($id TEXT PRIMARY KEY, $content TEXT, $isCompleted INTEGER)',
      );
    },
    version: 1,
  );

  /// Function to get all ToDos in database
  ///
  Future<List<ToDo>> getAllToDos() async {
    final db = await database();

    // Query the table for all The Todos.
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return ToDo.fromJson(maps[i]);
    });
  }

  /// Function to get all incomplete ToDos in database
  ///
  Future<List<ToDo>> getIncompleteToDos() async {
    final db = await database();

    // Query the table for all The Todos.
    final List<Map<String, dynamic>> maps = await db.query(tableName, where: "$isCompleted = 0");

    return List.generate(maps.length, (i) {
      return ToDo.fromJson(maps[i]);
    });
  }

  /// Function to get all completed ToDos in database
  ///
  Future<List<ToDo>> getCompletedToDos() async {
    final db = await database();

    // Query the table for all The Todos.
    final List<Map<String, dynamic>> maps = await db.query(tableName, where: "$isCompleted = 1");

    return List.generate(maps.length, (i) {
      return ToDo.fromJson(maps[i]);
    });
  }

  /// Function to insert a new ToDo into database, with the given [toDo]
  ///
  Future<int> insertToDo(ToDo toDo) async {
    // Get a reference to the database.
    final db = await database();

    return await db.insert(
      tableName,
      toDo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Function to update a ToDo in database, with the given [toDo]
  ///
  Future<int> updateToDo(ToDo toDo) async {
    // Get a reference to the database.
    final db = await database();

    // Update the given Todo.
    return await db.update(
      tableName,
      toDo.toJson(),
      where: '$id = ?',
      whereArgs: [toDo.id],
    );
  }

  /// Function to delete a ToDo in database, with the given [id]
  ///
  Future<int> deleteToDo(String todoId) async {
    // Get a reference to the database.
    final db = await database();

    // Remove the ToDo from the database.
    return await db.delete(
      tableName,
      // Use a `where` clause to delete a specific ToDo.
      where: '$id = ?',
      // Pass the ToDo's id as a whereArg to prevent SQL injection.
      whereArgs: [todoId],
    );
  }
}
