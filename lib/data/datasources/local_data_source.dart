import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource{
  final SharedPreferences prefs;
  LocalDataSource(this.prefs);

  static const String keyFirstLaunch = 'is_first_launch';
  static const String keyUserPurpose = 'user_purpose';

  bool getIsFirstLaunch() => prefs.getBool(keyFirstLaunch) ?? true;

  Future<void> savePurpose(String purpose) async{
    await prefs.setString(keyUserPurpose, purpose);
    await prefs.setBool(keyFirstLaunch, false);
  }
}