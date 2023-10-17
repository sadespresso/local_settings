import 'package:local_settings/src/entry.dart';

class PrimitiveSettingsEntry<T> extends SettingsEntry<T> {
  PrimitiveSettingsEntry({
    required super.key,
    required super.preferences,
    super.initialValue,
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
