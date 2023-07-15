import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsEntry<T> {
  final String key;
  final SharedPreferences preferences;

  final ValueNotifier<T?> valueNotifier = ValueNotifier(null);

  void Function(VoidCallback) get addListener => valueNotifier.addListener;
  void Function(VoidCallback) get removeListener =>
      valueNotifier.removeListener;

  SettingsEntry({
    required this.key,
    required this.preferences,
  }) {
    valueNotifier.value = get();
  }

  /// Retreives value, may be null
  T? get();

  /// Synonym for [get()]
  T? get value => get();

  /// Saves data to SharedPreferences
  ///
  /// Use [remove] for deleting the value
  Future<T> set(T data);

  /// Deletes entry from SharedPreferences
  Future<bool> remove() async {
    valueNotifier.value = null;
    return await preferences.remove(key);
  }
}

class PrimitiveSettingsEntry<T> extends SettingsEntry<T> {
  PrimitiveSettingsEntry({
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

    valueNotifier.value = data;

    return data;
  }
}
