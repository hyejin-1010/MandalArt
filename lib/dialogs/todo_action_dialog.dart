import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/common/theme.dart';

class TodoActionDialog extends StatelessWidget {
  const TodoActionDialog({
    Key? key,
    required this.onClick,
  }) : super(key: key);
  final Function(String) onClick;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextButton(
              onPressed: () => _clickActionButton('edit'),
              child: Text(
                '수정',
                style: TextStyle(fontSize: CommonTheme.medium),
              ),
            ),
            TextButton(
              onPressed: () => _clickActionButton('delete'),
              child: Text(
                '삭제',
                style: TextStyle(color: Colors.red, fontSize: CommonTheme.medium),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clickActionButton(String type) {
    Get.back();
    onClick(type);
  }
}
