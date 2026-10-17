import 'package:dio/dio.dart';

class Todo {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  // 생성자
  Todo({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  // 팩토리 생성자 dart객체로 변환
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int,
      todo: json['todo'] as String,
      completed: json['completed'] as bool,
      userId: json['userId'] as int,
    );
  }
}

// dart객체를 다시 String으로 변환
Future<List<Todo>> fetchTodos() async {
  final dio = Dio();

  final response = await dio.get(
    'https://dummyjson.com/todos',
    queryParameters: {'limit': 0},
  );

  final todosJson = response.data['todos'] as List;

  return todosJson
      .map((json) => Todo.fromJson(json as Map<String, dynamic>))
      .toList();
}
