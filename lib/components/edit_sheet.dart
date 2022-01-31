import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/common/theme.dart';
import 'package:madal_art/components/todo_list.dart';
import 'package:madal_art/controllers/data_controller.dart';
import 'package:madal_art/models/item.dart';
import 'package:madal_art/models/todo.dart';

class EditSheet extends StatefulWidget {
  EditSheet({
    Key? key,
    required this.group,
    required this.index,
    required this.item,
    required this.onSave,
  }) : super(key: key);

  final int group;
  final int index;
  final ItemModel item;
  final Function(String) onSave;

  @override
  State<EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<EditSheet> with TickerProviderStateMixin {
  final DataController _dataController = Get.find<DataController>();
  final TextEditingController _newTodoEditingController = TextEditingController();
  final TextEditingController _todoEditingController = TextEditingController();
  late AnimationController _animationController;
  List<TodoModel> _todos = [];

  @override
  void initState() {
    super.initState();
    _animationController = BottomSheet.createAnimationController(this);
    _newTodoEditingController.text = widget.item.content;
    _todos = widget.item.todos;
  }

  Widget _buildHeader() {
    return Row(
      children: <Widget>[
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            '취소',
            style: TextStyle(fontSize: CommonTheme.small),
          ),
        ),
        Expanded(child: Text(
          '목표 편집',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: CommonTheme.large,
          ),
        )),
        TextButton(
          onPressed: _save,
          child: Text(
            '저장',
            style: TextStyle(fontSize: CommonTheme.small),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _newTodoEditingController,
      decoration: InputDecoration(hintText: '목표를 입력하세요.'),
      style: TextStyle(fontSize: CommonTheme.medium),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      animationController: _animationController,
      onClosing: _onClosing,
      builder: (BuildContext context) {
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
            child: Column(
              children: <Widget>[
                _buildHeader(),
                const SizedBox(height: 20.0),
                _buildTextField(),
                Expanded(child: TodoList(
                  todos: _todos,
                  createTodo: _createTodo,
                  deleteTodo: _deleteTodo,
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  void _save() {
    if (widget.item.content != _newTodoEditingController.text) {
      widget.onSave(_newTodoEditingController.text);
    }
    Get.back();
  }

  void _createTodo(String content) async {
    try {
      TodoModel? todo = await _dataController.createTodo(widget.group, widget.index, content);
      if (todo == null) { return; }
      _todoEditingController.text = '';
      setState(() { });
    } catch (_) { }
  }

  void _deleteTodo(TodoModel todo) async {
    try {
      await _dataController.deleteTodo(widget.group, widget.index, todo);
    } catch (_) {}
    setState(() { });
  }

  void _onClosing() {}
}
