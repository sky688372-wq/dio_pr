import 'package:dio/dio.dart';
import 'package:dio_pr/core/model_class/todo.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      receiveTimeout: const Duration(seconds: 5),
      connectTimeout: const Duration(seconds: 5),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // 1. 모든 투두 리스트를 불러오는 함수
  static Future<List<Todo>> getAllTodo() async {
    final response = await _dio.get('/todos');
    final List<dynamic> jsonList = response.data['todos'];

    return jsonList
        .map((json) => Todo.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // 2. 새로운 투두를 추가하는 함수
  static Future<Todo> addNewTodo({
    required String todo,
    required bool completed,
    required int userId,
  }) async {
    final response = await _dio.post(
      '/todos/add',
      data: {'todo': todo, 'completed': completed, 'userId': userId},
    );
    return Todo.fromJson(response.data as Map<String, dynamic>);
  }
}
