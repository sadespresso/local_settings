import 'dart:developer';

import 'package:local_settings/local_settings.dart';

class SerializedSettingsEntry<T> extends SettingsEntry<T> {
  final T Function(String serialized) deserialize;
  final String Function(T data) serialize;

  SerializedSettingsEntry({
    required super.key,
    required super.preferences,
    required this.deserialize,
    required this.serialize,
    super.initialValue,
  });

  /// Returns [deserize]d data.
  ///
  /// Returns null if the data is not found or failed to deserialize.
  @override
  T? get() {
    final String? raw = preferences.getString(key);

    try {
      return deserialize(raw ?? "");
    } catch (e) {
      log("[LocalSettings] failed to deserialize($raw).", error: e);
    }

    return null;
  }

  /// Stores [data] as ISO8601 string in shared preferences
  @override
  Future<T> set(T data) async {
    await preferences.setString(key, serialize(data));

    valueNotifier.value = data;

    return data;
  }
}
