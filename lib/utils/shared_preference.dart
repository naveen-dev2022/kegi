import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {

  static SharedPreferences? _preferences;

  static Future<SharedPreferences?> getInstance() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  static const THEME_STATUS = "THEMESTATUS";
  static const String GUEST_MODE = 'GUESTMODE';
  static const GET_TOKEN = "GETTOKEN";
  static const GET_SESSION_WITH_COOKIE = "SESSIONANDCOOKIE";
  static const GET_LAT = "LATITUDE";
  static const GET_LONG = "LONGITUDE";
  static const GET_UID = "UID";
  static const GET_PROFILEPIC = "PROFILEPIC";
  static const GET_FIRSTNAME = "FIRSTNAME";
  static const GET_BASEURL = "BASEURL";
  static const GET_FAVORITE = "FAVORITE";
  static const GET_EMAIL = "EMAIL";
  static const GET_MOBILE = "MOBILE";

  dynamic setFavoriteList(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(GET_FAVORITE, value!);
  }

  Future<String> getFavoriteList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(GET_FAVORITE) ?? '';
  }

  dynamic setBaseUrl(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(GET_BASEURL, value!);
  }

  Future<String> getBaseUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(GET_BASEURL) ?? '';
  }

  dynamic setSessionWithCookie(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(GET_SESSION_WITH_COOKIE, value);
  }

  Future<String> getSessionWithCookie() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(GET_SESSION_WITH_COOKIE) ?? '';
  }

  dynamic setUid(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(GET_UID, value);
  }

  Future<String> getUid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(GET_UID) ?? '';
  }

  dynamic setProfilePic(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(GET_PROFILEPIC, value);
  }

  Future<String> getProfileImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(GET_PROFILEPIC) ?? '';
  }

  dynamic setEmail(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(GET_EMAIL, value);
  }

  Future<String> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(GET_EMAIL) ?? '';
  }

  dynamic setFirstName(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(GET_FIRSTNAME, value);
  }

  Future<String?>  getFirstName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(GET_FIRSTNAME) ?? '';
  }

  dynamic setLongitude(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(GET_LONG, value);
  }

  Future<double> getLongitude() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(GET_LONG)??0.0;
  }

  dynamic setLatitude(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(GET_LAT, value);
  }

  Future<double> getLatitude() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(GET_LAT)??0.0;
  }

  dynamic setGuestMode(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(GUEST_MODE, value);
  }

  Future<bool> getGuestMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(GUEST_MODE) ?? false;
  }

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }

  setToken(String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(GET_TOKEN, value!);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(GET_TOKEN) ?? '';
  }

  static Future<void> addStringToSF(String key, String? value) async {
    await _preferences!.setString(key, value!);
  }

  static String? getStringValueFromSF(String key) {
    String? stringValue = _preferences!.getString(key);
    return stringValue;
  }

  static Future<void> addDoubleToSF(String key, double? value) async {
    await _preferences!.setDouble(key, value!);
  }

  static double? getDoubleValueFromSF(String key) {
    double? stringValue = _preferences!.getDouble(key);
    return stringValue;
  }

  static void clearSF() {
    _preferences!.clear();
  }

}
