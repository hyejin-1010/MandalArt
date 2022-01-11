import 'package:get/get.dart';
import 'package:madal_art/common/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String fontSizeKey = 'HJ:MD:fontSize';

class SettingController extends GetxController {
  RxDouble fontSize = 14.0.obs;
  SharedPreferences? _sharedPreferences;

  @override
  void onInit() async {
    super.onInit();

    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      _getPrefsData();
    } catch (_) {}
  }

  void _getPrefsData() {
    double? newFontSize = _sharedPreferences!.getDouble(fontSizeKey);
    if (newFontSize != null) { setFontSize(newFontSize); }
  }

  void setFontSize(double newFontSize) {
    if (fontSize.value == newFontSize) { return; }
    fontSize.value = newFontSize;
    CommonTheme.setBaseSize(fontSize.value);
    _sharedPreferences?.setDouble(fontSizeKey, newFontSize);
  }
}