import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  const EditDialog({
    Key? key,
    required this.content,
    required this.done,
  }) : super(key: key);

  final String content;
  final Function(String) done;

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editingController.text = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _editingController,
              decoration: InputDecoration(
                hintText: '목표를 입력하세요.',
              ),
            ),
            ElevatedButton(
              onPressed: () => widget.done(_editingController.text),
              child: Text('DONE'),
            ),
          ],
        )
      ),    
    );
  }
}
