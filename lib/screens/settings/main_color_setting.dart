import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/controllers/setting_controller.dart';

class MainColorSetting extends StatefulWidget {
  const MainColorSetting({Key? key}) : super(key: key);

  @override
  State<MainColorSetting> createState() => _MainColorSettingState();
}

final List<Map<String, dynamic>> colors = [
  { 'value': 'amber', 'color': Colors.amber },
  { 'value': 'blue', 'color': Colors.blue },
  { 'value': 'red', 'color': Colors.redAccent },
  { 'value': 'teal', 'color': Colors.teal },
];

class _MainColorSettingState extends State<MainColorSetting> {
  final SettingController _settingController = Get.find<SettingController>();
  String _originMainColor = 'amber';
  String _mainColor = 'amber';
  Color _backgroundColor = Colors.amber;

  @override
  void initState() {
    super.initState();
    _originMainColor = _mainColor = _settingController.mainColor.value;
  }

  Widget _buildColorItem(Map<String, dynamic> color) {
    bool selected = color['value'] == _mainColor;

    return InkWell(
      onTap: () => _clickColor(color),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        height: 90.0,
        color: color['color'],
        child: selected ? Icon(Icons.check) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메인 컬러 설정'),
        backgroundColor: _backgroundColor,
        actions: [TextButton(
          onPressed: _originMainColor != _mainColor ? _save : null,
          child: Text(
            '저장',
            style: TextStyle(color: Theme.of(context).backgroundColor),
          ),
        )],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
        child: Row(
          children: colors.map((color) {
            return Expanded(child: _buildColorItem(color));
          }).toList(),
        ),
      ),
    );
  }

  void _clickColor(dynamic clickedColor) {
    setState(() {
      _mainColor = clickedColor['value'];
      _backgroundColor = clickedColor['color'];
    });
  }

  void _save() {
    _settingController.setMainColor(_mainColor);
    Get.back();
  }
}
