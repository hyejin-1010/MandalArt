import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/common/theme.dart';
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

  late AnimationController _animationController;
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _todoEditingController = TextEditingController();

  List<TodoModel> _todos = [];
  bool _updated = true;

  @override
  void initState() {
    super.initState();
    _animationController = BottomSheet.createAnimationController(this);
    _textEditingController.text = widget.item.content;
    _todos = widget.item.todos;
  }

  Widget _buildHeader() {
    if (!_updated) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            onPressed: _back,
            icon: Icon(Icons.cancel),
          ),
        ],
      );
    }

    return Row(
      children: <Widget>[
        TextButton(
          onPressed: _back,
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
          child: Text('저장'),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _textEditingController,
      decoration: InputDecoration(
        hintText: '목표를 입력하세요.',
      ),
      style: TextStyle(fontSize: CommonTheme.medium),
    );
  }

  Widget _buildTodoListBox() {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 25.0, bottom: 15.0),
          alignment: Alignment.topLeft,
          child: Text(
            'TODO',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: CommonTheme.large,
            ),
          ),
        ),
        TextField(
          controller: _todoEditingController,
          decoration: InputDecoration(hintText: '할 일 생성'),
          onSubmitted: (String? text) {
            if (text?.isNotEmpty != true) { return; }
            _createTodo(text!);
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _todos.map<Widget>((TodoModel todo) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    todo.content,
                    style: TextStyle(fontSize: CommonTheme.small),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      animationController: _animationController,
      onClosing: () {
      },
      builder: (BuildContext context) {
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
            child: Column(
              children: <Widget>[
                _buildHeader(),
                const SizedBox(height: 20.0),
                _buildTextField(),
                Expanded(child: _buildTodoListBox()),
              ],
            ),
          ),
        );
      },
    );
  }

  void _save() {
    if (widget.item.content != _textEditingController.text) {
      widget.onSave(_textEditingController.text);
    }
    _back();
  }

  void _back() {
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
}
