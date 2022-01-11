import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/controllers/setting_controller.dart';

const List<Map<String, String>> fontList = [
  { 'value': 'NanumSquare', 'text': '나눔 스퀘어' },
  { 'value': 'MaruBuri', 'text': '마루 부리' },
  { 'value': 'NanumGaRamYeonGgoc', 'text': '가람연꽃' },
];

class FontSettingScreen extends StatefulWidget {
  const FontSettingScreen({Key? key}) : super(key: key);

  @override
  State<FontSettingScreen> createState() => _FontSettingScreenState();
}

class _FontSettingScreenState extends State<FontSettingScreen> {
  final SettingController _settingController = Get.find<SettingController>();
  String? _selectedFont;

  @override
  void initState() {
    super.initState();
    _selectedFont = _settingController.fontFamily.value;
  }

  Widget _buildFontMenuItem(int index) {
    String value = fontList[index]['value']!;
    return RadioListTile(
      groupValue: _selectedFont,
      value: value,
      title: Text(
        fontList[index]['text']!,
        style: TextStyle(
          fontWeight: _selectedFont == value ? FontWeight.bold : FontWeight.normal,
          fontFamily: value,
        ),
      ),
      onChanged: (_) {
        setState(() {
          _selectedFont = value;
        });
      },
    );
  }

  Widget _buildDoneButton() {
    return TextButton(
      onPressed: _clickDoneButton,
      child: Text(
        '변경',
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('폰트 변경'),
        actions: [_buildDoneButton()],
      ),
      body: ListView.separated(
        itemCount: fontList.length,
        separatorBuilder: (_, __) => Divider(),
        itemBuilder: (BuildContext context, int index) {
          return _buildFontMenuItem(index);
        },
      ),
    );
  }

  void _clickDoneButton() {
    if (_selectedFont == null) { return; }
    _settingController.setFontFamily(_selectedFont!);
    Get.back();
  }
}
