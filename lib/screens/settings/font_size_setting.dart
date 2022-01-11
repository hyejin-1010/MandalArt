import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/controllers/setting_controller.dart';

class FontSizeSetting extends StatefulWidget {
  const FontSizeSetting({ Key? key }) : super(key: key);

  @override
  FontSizeSettingState createState() => FontSizeSettingState();
}

const double MIN_FONT_SIZE = 10.0;
const double MAX_FONT_SIZE = 22.0;

class FontSizeSettingState extends State<FontSizeSetting> {
  final SettingController _settingController = Get.find<SettingController>();
  late double fontSize;

  @override
  void initState() {
    super.initState();
    fontSize = _settingController.fontSize.value;
  }

  Widget _buildPreview() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
        '안녕하세요!\n만다라트를 사용해주셔서 정말 감사합니다 🙇‍♀️',
        style: TextStyle(
          fontSize: fontSize,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFontSizeSlidver() {
    return Slider(
      min: MIN_FONT_SIZE,
      max: MAX_FONT_SIZE,
      divisions: (MAX_FONT_SIZE - MIN_FONT_SIZE).toInt(),
      value: fontSize,
      onChanged: (double? newValue) {
        if (newValue == null) { return; }
        setState(() { fontSize = newValue; });
      },
    ); 
  }

  Widget _buildSettingButton() {
    return ElevatedButton(
      onPressed: _clickSettingButton,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
      child: Text(
        '설정',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('폰트 사이즈 설정'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildPreview(),
          _buildFontSizeSlidver(),
          Text(
            fontSize.toInt().toString(),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 25.0),
          _buildSettingButton(),
        ],
      ),
    );
  }

  void _clickSettingButton () {
    _settingController.setFontSize(fontSize);
    Get.back();
  }
}