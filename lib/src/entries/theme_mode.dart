import 'package:flutter/material.dart';
import 'package:local_settings/src/entry.dart';

class ThemeModeSettingsEntry extends SettingsEntry<ThemeMode> {
  ThemeModeSettingsEntry({
    required super.key,
    required super.preferences,
  });

  @override
  ThemeMode get() {
    final String name = preferences.getString(key) ?? ThemeMode.system.name;

    return ThemeMode.values.firstWhere(
      (element) => element.name == name,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Future<ThemeMode> set(ThemeMode data) async {
    await preferences.setString(key, data.name);

    valueNotifier.value = data;

    return data;
  }

  @override
  Future<bool> remove() async {
    return await preferences.remove(key);
  }
}
