import 'dart:convert';
import 'dart:developer';

import 'package:local_settings/local_settings.dart';

class JsonSettingsEntry<T> extends SettingsEntry<T> {
  final T Function(Map<String, dynamic> json) fromJson;
  final Map<String, dynamic> Function(T data) toJson;

  JsonSettingsEntry({
    required super.key,
    required super.preferences,
    required this.fromJson,
    required this.toJson,
    super.initialValue,
  });

  @override
  T? get() {
    final String? raw = preferences.getString(key);

    try {
      final Map<String, dynamic> json = jsonDecode(raw ?? "");

      return fromJson(json);
    } catch (e) {
      // Probably FormatException

      log("[LocalSettings] failed to jsonDecode($raw) due to $e");
    }

    return null;
  }

  @override
  Future<T> set(T data) async {
    await preferences.setString(key, jsonEncode(toJson(data)));

    valueNotifier.value = data;

    return data;
  }
}
