import 'dart:convert';

import 'package:local_settings/local_settings.dart';

class StringListSettingsEntry<T> extends SettingsEntry<List<T>> {
  /// Converts data to [Set] before saving,
  /// therefore allows no duplicates
  final bool removeDuplicates;

  final T Function(Map<String, dynamic> json) fromJson;
  final Map<String, dynamic> Function(T data) toJson;

  StringListSettingsEntry({
    required super.key,
    required super.preferences,
    required this.fromJson,
    required this.toJson,
    this.removeDuplicates = false,
  });

  /// No duplicates. See [removeDuplicates]
  StringListSettingsEntry.set({
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

  Set<T>? get asSet => get()?.toSet();

  /// Adds an item to the list, and calls [set] with the updated value
  Future<List<T>> addItem(T value) async {
    final List<T> list = get() ?? [];

    list.add(value);

    return await set(list);
  }

  /// Adds an item to the list, and calls [set] with the updated value
  Future<List<T>> addAll(List<T> value) async {
    final List<T> list = get() ?? [];

    list.addAll(value);

    return await set(list);
  }

  /// Removes an item from the list, and calls [set] with the updated value
  ///
  /// If there are multiple entries, only removes the first occurence
  Future<List<T>> removeItem(T value) async {
    final List<T> list = get() ?? [];

    if (list.isEmpty) return list;

    final bool removed = list.remove(value);

    // If the item wasn't there, we can save the trip
    if (!removed) return list;

    return await set(list);
  }

  /// Removes an item from the list, and calls [set] with the updated value
  ///
  /// If there are multiple entries, only removes the first occurence
  Future<List<T>> removeAll(List<T> value) async {
    final List<T> list = get() ?? [];

    if (list.isEmpty) return list;

    final List<bool> removedStatuses =
        value.map((item) => list.remove(item)).toList();

    // If the item wasn't there, we can save the trip
    if (!removedStatuses.any((x) => x)) return list;

    return await set(list);
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
