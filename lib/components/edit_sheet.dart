import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/common/theme.dart';

class EditSheet extends StatefulWidget {
  EditSheet({
    Key? key,
    required this.content,
    required this.onSave,
  }) : super(key: key);

  final String content;
  final Function(String) onSave;

  @override
  State<EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<EditSheet> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController _textEditingController = TextEditingController();
  bool _updated = true;

  @override
  void initState() {
    super.initState();
    _animationController = BottomSheet.createAnimationController(this);
    _textEditingController.text = widget.content;
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
              ],
            ),
          ),
        );
      },
    );
  }

  void _save() {
    if (widget.content != _textEditingController.text) {
      widget.onSave(_textEditingController.text);
    }
    _back();
  }

  void _back() {
    Get.back();
  }
}
