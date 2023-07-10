import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsEntry<T> {
  final String key;
  final SharedPreferences preferences;

  const SettingsEntry({
    required this.key,
    required this.preferences,
  });

  /// Retreives value, may be null
  T? get();

  /// Saves data to SharedPreferences
  ///
  /// Use [remove] for deleting the value
  Future<T> set(T data);

  /// Deletes entry from SharedPreferences
  Future<bool> remove() async {
    return await preferences.remove(key);
  }
}

class PrimitiveSettingsEntry<T> extends SettingsEntry<T> {
  const PrimitiveSettingsEntry({
    required super.key,
    required super.preferences,
  });

  @override
  T? get() {
    return preferences.get(key) as T?;
  }

  @override
  Future<T> set(T data) async {
    if (data is String) {
      await preferences.setString(key, data);
    } else if (data is Iterable<String>) {
      await preferences.setStringList(key, data.toList());
    } else if (data is int) {
      await preferences.setInt(key, data);
    } else if (data is double) {
      await preferences.setDouble(key, data);
    } else if (data is bool) {
      await preferences.setBool(key, data);
    } else {
      throw UnimplementedError(
          "Implemented types are: String, Iterable<String>, int, double, bool");
    }

    return data;
  }
}
