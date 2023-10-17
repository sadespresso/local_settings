import 'package:local_settings/local_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// I have setup a little lazy-loaded singleton
/// which is responsible for all the settings.
///
/// You can do yours without a wrapper class,
/// but this is what I recommend :D
class LocalSettings {
  static LocalSettings? instance;

  final SharedPreferences preferences;

  late final ThemeModeSettingsEntry themeMode;
  late final BoolSettingsEntry noAnimation;
  late final DateTimeSettingsEntry lastLoginTime;
  late final PrimitiveSettingsEntry<int> loginCount;
  late final PrimitiveSettingsEntry<String> importantText;

  LocalSettings._internal(this.preferences) {
    themeMode = ThemeModeSettingsEntry(
      key: "themeMode",
      preferences: preferences,
    );

    noAnimation = BoolSettingsEntry(
      key: "noAnimation",
      preferences: preferences,
      initialValue: false,
    );

    lastLoginTime = DateTimeSettingsEntry(
      key: "lastLoginTime",
      preferences: preferences,
    );

    loginCount = PrimitiveSettingsEntry<int>(
      key: "loginCount",
      preferences: preferences,
    );

    importantText = PrimitiveSettingsEntry<String>(
      key: "importantText",
      preferences: preferences,
    );
  }

  static initialize(SharedPreferences preferences) {
    instance = LocalSettings._internal(preferences);

    return instance;
  }

  factory LocalSettings() {
    if (instance == null) {
      throw Exception("Call LocalSettings.initialize() first");
    }

    return instance!;
  }
}

// Usage
// LocalSettings().themeMode.set(ThemeMode.light);
//
