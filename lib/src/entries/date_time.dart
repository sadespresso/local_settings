import 'package:local_settings/local_settings.dart';

class DateTimeSettingsEntry extends SettingsEntry<DateTime> {
  const DateTimeSettingsEntry({
    required super.key,
    required super.preferences,
  });

  /// Returns parsed [DateTime], or null if failed to do so
  ///
  /// See also:
  /// * [utc]
  /// * [local]
  @override
  DateTime? get() {
    final String? raw = preferences.getString(key);

    return DateTime.tryParse(raw ?? "");
  }

  /// Returns DateTime in UTC timezone
  ///
  /// See also:
  /// * [local]
  DateTime? get utc => get()?.toUtc();

  /// Returns DateTime in local timezone
  ///
  /// See also:
  /// * [utc]
  DateTime? get local => get()?.toLocal();

  /// Stores [data] as ISO8601 string in shared preferences
  @override
  Future<DateTime> set(DateTime data) async {
    await preferences.setString(key, data.toIso8601String());

    return data;
  }
}
