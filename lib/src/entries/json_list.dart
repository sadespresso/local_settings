import 'dart:convert';

import 'package:local_settings/local_settings.dart';

class JsonListSettingsEntry<T> extends SettingsEntry<List<T>> with ListEntry {
  /// Converts data to [Set] before saving,
  /// therefore allows no duplicates
  final bool removeDuplicates;

  final T Function(Map<String, dynamic> json) fromJson;
  final Map<String, dynamic> Function(T data) toJson;

  JsonListSettingsEntry({
    required super.key,
    required super.preferences,
    required this.fromJson,
    required this.toJson,
    super.initialValue,
    this.removeDuplicates = false,
  });

  /// No duplicates. See [removeDuplicates]
  JsonListSettingsEntry.set({
    required super.key,
    required super.preferences,
    required this.fromJson,
    required this.toJson,
  }) : removeDuplicates = true;

  @override
  List<T>? get() {
    final raw = preferences.getStringList(key);

    if (raw == null) return null;

    return raw.map((e) => fromJson(jsonDecode(e))).toList();
  }

  @override
  Future<List<T>> set(List<T> data) async {
    final List<String> encoded = data.map(toJson).map(jsonEncode).toList();

    await preferences.setStringList(
      key,
      removeDuplicates ? encoded.toSet().toList() : encoded,
    );

    valueNotifier.value = data;

    return data;
  }
}
