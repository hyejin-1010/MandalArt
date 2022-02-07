import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/common/theme.dart';
import 'package:madal_art/dialogs/todo_action_dialog.dart';
import 'package:madal_art/controllers/data_controller.dart';
import 'package:madal_art/models/todo.dart';

class TodoList extends StatefulWidget {
  const TodoList({
    Key? key,
    required this.todos,
    required this.createTodo,
    required this.deleteTodo,
  }) : super(key: key);

  final List<TodoModel> todos;
  final Function(String) createTodo;
  final Function(TodoModel) deleteTodo;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final DataController _dataController = Get.find<DataController>();
  final TextEditingController _todoEditingController = TextEditingController();
  final Map<int, TextEditingController> _editTodoController = {};
  final Map<int, FocusNode> _editFocusNode = {};
  TodoModel? _focusTodo;

  Widget _buildTodoItem(int index) {
    TodoModel todo = widget.todos[index];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () => _clickCheck(todo),
            child: Icon(
              todo.isDone ? Icons.check_circle : Icons.circle_outlined,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: _focusTodo?.id == todo.id
              ? FocusScope(child: Focus(
                onFocusChange: (bool focus) => _onFocusChange(todo, focus),
                child: TextField(
                  controller: _editTodoController[todo.id],
                  focusNode: _editFocusNode[todo.id],
                  onSubmitted: (_) => _doneEditTodo(),
                  style: TextStyle(fontSize: CommonTheme.xSmall),
                ),
              )) : Text(
                todo.content,
                style: TextStyle(fontSize: CommonTheme.xSmall),
              ),
          ),
          IconButton(
            onPressed: () => _clickMoreButton(todo),
            icon: Icon(Icons.more_vert),
            iconSize: CommonTheme.medium,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int doneTodoCount = widget.todos.where((todo) => todo.isDone).length;
    int percentage = widget.todos.length == 0 ? 0 : ((doneTodoCount / widget.todos.length) * 100).toInt();

    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 25.0),
          alignment: Alignment.topLeft,
          child: Text(
            'TODO (${widget.todos.length}, $percentage%)',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: CommonTheme.medium,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5.0, bottom: 10.0),
          alignment: Alignment.topLeft,
          child: Text(
            '성취율 : $percentage%',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: CommonTheme.small,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        TextField(
          controller: _todoEditingController,
          decoration: InputDecoration(hintText: '새로운 할 일'),
          style: TextStyle(fontSize: CommonTheme.xSmall),
          onSubmitted: _createTodo,
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

  void _doneEditTodo() async {
    try {
      await _updateTodo();
      _editFocusNode[_focusTodo!.id]!.unfocus();
    } catch (_) {}
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

  void _clickMoreButton(TodoModel todo) {
    Get.dialog(TodoActionDialog(
      onClick: (String type) {
        switch (type) {
          case 'edit': return _clickEditButton(todo);
          case 'delete': return widget.deleteTodo(todo);
        }
      },
    ));
  }

  void _clickEditButton(TodoModel todo) async {
    try {
      await _updateTodo();
    } catch (_) {}
    if (_editTodoController[todo.id] == null) {
      _editTodoController[todo.id] = TextEditingController();
      _editFocusNode[todo.id] = FocusNode();
    }
    _editTodoController[todo.id]!.text = todo.content;
    setState(() { _focusTodo = todo; });
  }

  void _clickCheck(TodoModel todo) async {
    try {
      await _dataController.updateTodoDone(todo);
      setState(() {});
    } catch (_) {}
  }

  void _createTodo(String? text) {
    if (text?.isNotEmpty != true) { return; }
    widget.createTodo(text!);
    _todoEditingController.text = '';
  }
}
