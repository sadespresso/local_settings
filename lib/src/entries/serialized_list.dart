import 'package:local_settings/local_settings.dart';

class SerializedListSettingsEntry<T> extends SettingsEntry<List<T>>
    with ListEntry {
  /// Converts data to [Set] before saving,
  /// therefore allows no duplicates
  final bool removeDuplicates;

  final T Function(String serialized) deserialize;
  final String Function(T data) serialize;

  SerializedListSettingsEntry({
    required super.key,
    required super.preferences,
    required this.deserialize,
    required this.serialize,
    super.initialValue,
    this.removeDuplicates = false,
  });

  /// No duplicates. See [removeDuplicates]
  SerializedListSettingsEntry.set({
    required super.key,
    required super.preferences,
    required this.deserialize,
    required this.serialize,
  }) : removeDuplicates = true;

  @override
  List<T>? get() {
    final raw = preferences.getStringList(key);

    if (raw == null) return null;

    return raw.map(deserialize).toList();
  }

  @override
  Future<List<T>> set(List<T> data) async {
    final List<String> encoded = data.map(serialize).toList();

    await preferences.setStringList(
      key,
      removeDuplicates ? encoded.toSet().toList() : encoded,
    );

    valueNotifier.value = data;

    return data;
  }
}
