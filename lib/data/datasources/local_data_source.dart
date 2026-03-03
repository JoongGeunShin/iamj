import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  final SharedPreferences prefs;
  LocalDataSource(this.prefs);

  static const String keyUserPurpose = 'user_purpose';

  String? getPurpose() => prefs.getString(keyUserPurpose);

  Future<void> savePurpose(String purpose) async {
    await prefs.setString(keyUserPurpose, purpose);
  }
}