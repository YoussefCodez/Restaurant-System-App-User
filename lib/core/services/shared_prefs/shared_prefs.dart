import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences preferences;
  static init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static saveOnBoardingStatus(bool status) {
    preferences.setBool("onBoardingStatus", status);
  }

  static bool getOnBoardingStatus() {
    return preferences.getBool("onBoardingStatus") ?? false;
  }

  static saveRememberMeStatus(bool status) {
    preferences.setBool("rememberMeStatus", status);
  }

  static bool getRememberMeStatus() {
    return preferences.getBool("rememberMeStatus") ?? false;
  }
}
