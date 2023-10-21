import 'package:local_settings/local_settings.dart';

class StringListSettingsEntry extends SettingsEntry<List<String>>
    with ListEntry {
  /// Converts data to [Set] before saving,
  /// therefore allows no duplicates
  final bool removeDuplicates;

  StringListSettingsEntry({
    required super.key,
    required super.preferences,
    super.initialValue,
    this.removeDuplicates = false,
  });

  /// No duplicates. See [removeDuplicates]
  StringListSettingsEntry.set({
    required super.key,
    required super.preferences,
  }) : removeDuplicates = true;

  @override
  List<String>? get() {
    return preferences.getStringList(key);
  }

  @override
  Future<List<String>> set(List<String> data) async {
    await preferences.setStringList(
      key,
      removeDuplicates ? data.toSet().toList() : data,
    );

    valueNotifier.value = data;

    return data;
  }
}
