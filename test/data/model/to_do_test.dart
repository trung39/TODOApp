import 'package:test/test.dart';
import 'package:to_do_app/data/model/to_do.dart';

void main() {
  group('Testing ToDo Model', () {

    String toDoContent = "TestContent";

    test('A new Todo is created with the given content, and status is [false] (incomplete)', () {
      // The ToDo id is random so we don't have a test for it
      ToDo todo = ToDo(content: toDoContent);
      expect(todo.content, toDoContent);
      expect(todo.isCompleted, false);
    });

    test("A map of todo information should be returned", () {
      ToDo todo = ToDo(content: toDoContent);
      Map<String, dynamic> expectedMap = {
        'id': todo.id,
        'content': todo.content,
        'is_completed': todo.isCompleted ? 1 : 0,
      };
      expect(expectedMap, todo.toJson());
    });

    test("A ToDo should be create with the same properties in the given map data", () {
      Map<String, dynamic> mapData = {
        'id': "abcxyz-1234",
        'content': toDoContent,
        'is_completed': 0,
      };
      ToDo todo = ToDo.fromJson(mapData);
      expect(todo.toJson(), mapData);

      Map<String, dynamic> mapData2 = {
        'id': "abcxyz-6789",
        'content': toDoContent,
        'is_completed': 1,
      };
      ToDo todo2 = ToDo.fromJson(mapData2);
      expect(todo2.toJson(), mapData2);
    });

  });
}