import 'package:flutter/material.dart';
import 'package:madal_art/common/theme.dart';
import 'package:madal_art/models/todo.dart';

class TodoList extends StatelessWidget {
  TodoList({
    Key? key,
    required this.todos,
    required this.createTodo,
  }) : super(key: key);

  final TextEditingController _todoEditingController = TextEditingController();

  final List<TodoModel> todos;
  final Function(String) createTodo;

  Widget _buildTodoItem(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(
            todos[index].content,
            style: TextStyle(fontSize: CommonTheme.xSmall),
          )),
          IconButton(
            onPressed: () => null,
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
            createTodo(text!);
          },
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (_, __) => const Divider(),
            itemCount: todos.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildTodoItem(index);
            },
          ),
        ),
      ],
    );
  }
}
