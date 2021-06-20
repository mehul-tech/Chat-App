import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String sharedPrefUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPrefUserNameKey = "USERNAMEKEY";
  static String sharedPrefUserEmailKey = "USEREMAILKEY";

  static Future<bool> saveUserLoggedInSharedPref(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPrefUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPref(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefUserNameKey, username);
  }

  static Future<bool> saveUserEmailSharedPref(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefUserEmailKey, email);
  }


  static Future<bool> getUserLoggedInSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPrefUserLoggedInKey);
  }

  static Future<String> getUserNameSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefUserNameKey);
  }

  static Future<String> getUserEmailSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefUserEmailKey);
  }
}
