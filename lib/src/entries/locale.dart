import 'dart:ui';
import 'package:local_settings/src/entry.dart';

class LocaleSettingsEntry extends SettingsEntry<Locale> {
  /// Delimiter for stringifying/parsing [Locale]
  final String delimiter;

  LocaleSettingsEntry({
    required super.key,
    required super.preferences,
    this.delimiter = "-",
  });

  @override
  Locale? get() {
    final String? raw = preferences.getString(key);

    // TODO maybe do a little validation here...
    // mn_Mong_MN -> mn, Mong, MN
    final List<String>? tokens = raw?.split(delimiter);

    if (tokens == null || tokens.isEmpty) return null;

    final String? scriptCode = tokens.length >= 3 ? tokens[1] : null;
    final String? countryCode = tokens.length >= 2
        ? (scriptCode == null ? tokens[1] : tokens[3])
        : null;

    return Locale.fromSubtags(
      languageCode: tokens.first,
      scriptCode: scriptCode,
      countryCode: countryCode,
    );
  }

  @override
  Future<Locale> set(Locale data) async {
    final String stringified = [
      data.languageCode,
      data.scriptCode,
      data.countryCode
    ].where((element) => element != null).cast<String>().join(delimiter);

    await preferences.setString(key, stringified);

    valueNotifier.value = data;

    return data;
  }
}
