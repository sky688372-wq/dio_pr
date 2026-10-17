import 'package:dio_pr/core/api_service.dart';
import 'package:dio_pr/core/model_class/todo.dart';
import 'package:flutter/material.dart';

class AddNewTodoScreen extends StatefulWidget {
  const AddNewTodoScreen({super.key});

  @override
  State<AddNewTodoScreen> createState() => _AddNewTodoScreenState();
}

class _AddNewTodoScreenState extends State<AddNewTodoScreen> {
  final TextEditingController _todoCtrl = TextEditingController();
  final TextEditingController _userIdCtrl = TextEditingController();

  // Checkbox 상태 관리용 변수
  bool _isCompleted = false;

  // 로딩 상태 변수
  bool _isLoading = false;

  // 응답 결과를 저장할 변수
  Todo? _resultTodo;

  @override
  void dispose() {
    _todoCtrl.dispose();
    _userIdCtrl.dispose();
    super.dispose();
  }

  // 투두 추가 요청 함수
  Future<void> _submitTodo() async {
    // 1. 유효성 검사
    if (_todoCtrl.text.trim().isEmpty || _userIdCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 항목을 입력해주세요.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 2. ApiService 호출
      final newTodo = await ApiService.addNewTodo(
        todo: _todoCtrl.text.trim(),
        completed: _isCompleted,
        userId: int.parse(_userIdCtrl.text.trim()),
      );

      if (!mounted) return;

      // 3. 응답 결과 저장 (화면 갱신)
      setState(() {
        _resultTodo = newTodo;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('투두 추가 실패: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 투두 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 투두 내용 입력
              TextField(
                controller: _todoCtrl,
                decoration: const InputDecoration(
                  labelText: '할 일 (Todo)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 2. 유저 ID 입력
              TextField(
                controller: _userIdCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '유저 ID (User ID)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 3. 완료 여부 체크박스
              CheckboxListTile(
                title: const Text('완료 여부'),
                value: _isCompleted,
                onChanged: (value) {
                  setState(() {
                    _isCompleted = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 24),

              // 4. 전송 버튼
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitTodo,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('투두 추가하기'),
                ),
              ),

              const SizedBox(height: 32),

              // 5. 응답 결과 표시 영역
              if (_resultTodo != null) ...[
                const Text(
                  '응답 결과 (Response Data)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  color: Colors.grey.shade100,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('id: ${_resultTodo!.id}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Divider(),
                        Text('todo: ${_resultTodo!.todo}'),
                        Text('completed: ${_resultTodo!.completed}'),
                        Text('userId: ${_resultTodo!.userId}'),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}