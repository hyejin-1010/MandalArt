import 'package:get/get.dart';
import 'package:madal_art/common/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String fontSizeKey = 'HJ:MD:fontSize';
const String fontFamilyKey = 'HJ:MD:fontFamily';

class SettingController extends GetxController {
  SharedPreferences? _sharedPreferences;

  RxString fontFamily = 'NanumSquare'.obs;
  RxDouble fontSize = 14.0.obs;

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
    String? newFontFamily = _sharedPreferences!.getString(fontFamilyKey);
    if (newFontFamily != null) { setFontFamily(newFontFamily); }
  }

  void setFontSize(double newFontSize) {
    if (fontSize.value == newFontSize) { return; }
    fontSize.value = newFontSize;
    CommonTheme.setBaseSize(fontSize.value);
    _sharedPreferences?.setDouble(fontSizeKey, newFontSize);
  }

  void setFontFamily(String newFontFamily) {
    if (fontFamily.value == newFontFamily) { return; }
    fontFamily.value = newFontFamily;
    _sharedPreferences?.setString(fontFamilyKey, newFontFamily);
  }
}