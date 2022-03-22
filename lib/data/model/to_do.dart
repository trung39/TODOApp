
import 'package:uuid/uuid.dart';

class ToDo {
  ToDo({
    String? id,
    this.content,
    this.isCompleted = false,
  })  : assert(
  id == null || id.isEmpty,
  'id can not be null or empty',
  ),
        id = id ?? const Uuid().v4();

  ToDo.fromJson(dynamic json) {
    id = json['id'];
    content = json['content'];
    isCompleted = json['is_completed'] == 1;
  }
  String? id;
  String? content;
  bool isCompleted = false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['content'] = content;
    map['is_completed'] = isCompleted ? 1 : 0;
    return map;
  }

  @override
  String toString() {
    return 'ToDo{id: $id, content: $content, isCompleted: $isCompleted}';
  }
}