import 'package:local_settings/local_settings.dart';

/// Non-null bool settings entry with default value.
///
/// Use PrimitiveSettingsEntry<bool> for nullable entries
///
/// Altough [valueNotifier] is nullably typed, its value
/// will always be non-null.
class BoolSettingsEntry extends PrimitiveSettingsEntry<bool> {
  /// If [this]' current value is null, this is automatically set
  final bool defaultValue;

  BoolSettingsEntry({
    required super.key,
    required super.preferences,
    required this.defaultValue,
  }) {
    print(valueNotifier.value);
  }

  /// Gets the boolean value for this entry.
  ///
  /// If the value is null, sets value to [defaultValue], but does not await for the result.
  ///
  /// May cause race-condition
  @override
  bool get() {
    final bool? currentValue = super.get();

    if (currentValue != null) return currentValue;

    // TODO fix Race-condition issues
    set(defaultValue);
    return defaultValue;
  }

  /// Awaits for the .set() call to finish
  Future<bool> toggleAsync() async {
    final bool currentValue = get();

    return await set(!currentValue);
  }

  /// Does not wait for .set() to end.
  ///
  /// Might cause race-condition
  bool toggle() {
    final bool currentValue = get();

    set(!currentValue);

    return !currentValue;
  }

  ///
  @override
  Future<bool> remove() {
    valueNotifier.value = defaultValue;
    return super.remove();
  }
}
