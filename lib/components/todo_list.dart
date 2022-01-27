import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/common/theme.dart';
import 'package:madal_art/controllers/data_controller.dart';
import 'package:madal_art/models/todo.dart';

class TodoList extends StatefulWidget {
  TodoList({
    Key? key,
    required this.todos,
    required this.createTodo,
  }) : super(key: key);

  final List<TodoModel> todos;
  final Function(String) createTodo;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final DataController _dataController = Get.find<DataController>();
  final TextEditingController _todoEditingController = TextEditingController();
  final Map<int, TextEditingController> _editTodoController = {};

  TodoModel? _focusTodo;

  Widget _buildTodoItem(int index) {
    TodoModel todo = widget.todos[index];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _focusTodo?.id == todo.id
              ? FocusScope(child: Focus(
                onFocusChange: (bool focus) => _onFocusChange(todo, focus),
                child: TextField(controller: _editTodoController[todo.id]),
              )) : Text(
                todo.content,
                style: TextStyle(fontSize: CommonTheme.xSmall),
              ),
          ),
          IconButton(
            onPressed: () => _clickEditButton(todo),
            icon: Icon(Icons.edit),
            iconSize: CommonTheme.small,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 25.0, bottom: 15.0),
          alignment: Alignment.topLeft,
          child: Text(
            'TODO',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: CommonTheme.medium,
            ),
          ),
        ),
        TextField(
          controller: _todoEditingController,
          decoration: InputDecoration(hintText: '새로운 할 일'),
          style: TextStyle(fontSize: CommonTheme.xSmall),
          onSubmitted: (String? text) {
            if (text?.isNotEmpty != true) { return; }
            widget.createTodo(text!);
          },
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (_, __) => const Divider(),
            itemCount: widget.todos.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildTodoItem(index);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _updateTodo() async {
    if (_focusTodo == null) { return; }
    String content = _editTodoController[_focusTodo!.id]!.text;
    if (_focusTodo!.content == content) { return; }
    setState(() { _focusTodo!.content = content; });

    try {
      await _dataController.updateTodo(_focusTodo!, content);
    } catch (_) {}
  }

  void _onFocusChange(TodoModel todo, bool focus) async {
    if (focus || _focusTodo?.id != todo.id) { return; }
    try {
      await _updateTodo();
    } catch (_) {}
    setState(() { _focusTodo = null; });
  }

  void _clickEditButton(TodoModel todo) async {
    try {
      await _updateTodo();
    } catch (_) {}
    if (_editTodoController[todo.id] == null) {
      _editTodoController[todo.id] = TextEditingController();
    }
    _editTodoController[todo.id]!.text = todo.content;
    setState(() { _focusTodo = todo; });
  }
}
