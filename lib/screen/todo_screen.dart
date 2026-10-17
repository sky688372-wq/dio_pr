import 'package:dio_pr/core/api_service.dart';
import 'package:dio_pr/core/model_class/todo.dart';
import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  // 투두 데이터를 비동기로 받아올 Future 변수
  late Future<List<Todo>> todos;

  @override
  void initState() {
    super.initState();
    // 화면이 생성될 때 API 호출
    todos = ApiService.getAllTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      // Future의 상태(로딩 중, 성공, 에러)에 따라 화면을 분기 처리
      // Future변수에 접근하려면 사용해야함
      // 프로바이더의 컨슈머처럼 지속적 관찰이 아님, 딱 한번 로딩부터 결과 응답까지 처리하는게 FutureBuilder임
      body: FutureBuilder<List<Todo>>(
        future: todos,
        builder: (context, snapshot) {
          // 1. 데이터 로딩 중일 때
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2. 에러가 발생했을 때
          if (snapshot.hasError) {
            return Center(
              child: Text('오류가 발생했습니다: ${snapshot.error}'),
            );
          }

          // 3. 데이터가 성공적으로 로드되었을 때
          if (snapshot.hasData) {
            final todoList = snapshot.data!;

            // 데이터가 비어있는 경우
            if (todoList.isEmpty) {
              return const Center(
                child: Text('등록된 할 일이 없습니다.'),
              );
            }

            // 받아온 데이터로 리스트뷰 생성
            return ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                final todo = todoList[index];
                return ListTile(
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: null, // 단순 조회용
                  ),
                  title: Text(
                    todo.todo,
                    style: TextStyle(
                      decoration: todo.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text('User ID: ${todo.userId}'),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}