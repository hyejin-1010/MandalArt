import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({ Key? key }) : super(key: key);

  final List<Map<String, String>> _settingFields = [
    { 'key': 'fontSize', 'text': '폰트 사이즈 변경' },
    { 'key': 'font', 'text': '폰트 변경' },
    { 'key': 'color', 'text': '메인 컬러 변경' },
  ];

  Widget _buildMenuItem(int index) {
    return InkWell(
      onTap: () => _clickMenu(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Text(_settingFields[index]['text'] ?? ''),
      ),
    ); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: ListView.separated(
          separatorBuilder: (_, __) => Divider(),
          padding: EdgeInsets.zero,
          itemCount: _settingFields.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildMenuItem(index);
          },
        ),
      ),
    );
  }

  void _clickMenu(int index) {
  }
}