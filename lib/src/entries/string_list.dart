import 'package:local_settings/local_settings.dart';

class StringListSettingsEntry extends SettingsEntry<List<String>> {
  /// Converts data to [Set] before saving,
  /// therefore allows no duplicates
  final bool removeDuplicates;

  const StringListSettingsEntry({
    required super.key,
    required super.preferences,
    this.removeDuplicates = false,
  });

  /// No duplicates. See [removeDuplicates]
  const StringListSettingsEntry.set({
    required super.key,
    required super.preferences,
  }) : removeDuplicates = true;

  @override
  List<String>? get() {
    return preferences.getStringList(key);
  }

  Set<String>? get asSet => get()?.toSet();

  /// Adds an item to the list, and calls [set] with the updated value
  Future<List<String>> addItem(String value) async {
    final List<String> list = get() ?? [];

    list.add(value);

    return await set(list);
  }

  /// Adds an item to the list, and calls [set] with the updated value
  Future<List<String>> addAll(List<String> value) async {
    final List<String> list = get() ?? [];

    list.addAll(value);

    return await set(list);
  }

  /// Removes an item from the list, and calls [set] with the updated value
  ///
  /// If there are multiple entries, only removes the first occurence
  Future<List<String>> removeItem(String value) async {
    final List<String> list = get() ?? [];

    if (list.isEmpty) return list;

    final bool removed = list.remove(value);

    // If the item wasn't there, we can save the trip
    if (!removed) return list;

    return await set(list);
  }

  /// Removes an item from the list, and calls [set] with the updated value
  ///
  /// If there are multiple entries, only removes the first occurence
  Future<List<String>> removeAll(List<String> value) async {
    final List<String> list = get() ?? [];

    if (list.isEmpty) return list;

    final List<bool> removedStatuses =
        value.map((item) => list.remove(item)).toList();

    // If the item wasn't there, we can save the trip
    if (!removedStatuses.any((x) => x)) return list;

    return await set(list);
  }

  @override
  Future<List<String>> set(List<String> data) async {
    await preferences.setStringList(
      key,
      removeDuplicates ? data.toSet().toList() : data,
    );

    return data;
  }
}
