import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_betting_simulator/core/services/shared_preferences/shared_preferences_service.dart';

class DefaultSharedPreferencesService extends SharedPreferencesService {
  final SharedPreferences preferences;

  DefaultSharedPreferencesService({required this.preferences});

  @override
  dynamic get(String key) {
    // Retrieve data from shared preferences
    return preferences.get(key);
  }

  @override
  Future<void> set(String key, value) async {
    // Save data to shared preferences
    if (value is String) {
      preferences.setString(key, value);
    } else if (value is int) {
      preferences.setInt(key, value);
    } else if (value is double) {
      preferences.setDouble(key, value);
    } else if (value is bool) {
      preferences.setBool(key, value);
    } else if (value is List<String>) {
      preferences.setStringList(key, value);
    } else {
      throw ArgumentError('Unsupported type: ${value.runtimeType}');
    }
  }
}
