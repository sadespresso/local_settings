import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_settings/local_settings.dart';
import 'package:test/test.dart';

/// I have setup a little lazy-loaded singleton
/// which is responsible for all the settings.
///
/// You can do yours without a wrapper class,
/// but this is what I recommend :D
class LocalSettings {
  static LocalSettings? instance;

  final SharedPreferences preferences;

  late final LocaleSettingsEntry locale;
  late final ThemeModeSettingsEntry themeMode;
  late final BoolSettingsEntry boolean1;
  late final BoolSettingsEntry boolean2;
  late final DateTimeSettingsEntry dateTime;
  late final PrimitiveSettingsEntry<int> primitiveInt;
  late final PrimitiveSettingsEntry<String> primitiveString;
  late final PrimitiveSettingsEntry<double> primitiveDouble;
  late final PrimitiveSettingsEntry<bool> primitiveBool;
  late final PrimitiveSettingsEntry<List<String>> primitiveListString;

  LocalSettings._internal(this.preferences) {
    locale = LocaleSettingsEntry(
      key: "locale",
      preferences: preferences,
    );
    themeMode = ThemeModeSettingsEntry(
      key: "themeMode",
      preferences: preferences,
    );
    boolean1 = BoolSettingsEntry(
        key: "booleanTrue", preferences: preferences, defaultValue: true);
    boolean2 = BoolSettingsEntry(
        key: "booleanFalse", preferences: preferences, defaultValue: false);
    dateTime = DateTimeSettingsEntry(
      key: "dateTime",
      preferences: preferences,
    );
    primitiveInt = PrimitiveSettingsEntry<int>(
      key: "primitiveInt",
      preferences: preferences,
    );
    primitiveString = PrimitiveSettingsEntry<String>(
      key: "primitiveString",
      preferences: preferences,
    );
    primitiveDouble = PrimitiveSettingsEntry<double>(
      key: "primitiveDouble",
      preferences: preferences,
    );
    primitiveBool = PrimitiveSettingsEntry<bool>(
      key: "primitiveBool",
      preferences: preferences,
    );
    primitiveListString = PrimitiveSettingsEntry<List<String>>(
      key: "primitiveListString",
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

void main() async {
// TestWidgetsFlutterBinding

  // SharedPreferences.setMockInitialValues({});
  SharedPreferences.setMockInitialValues({
    "dateTime": DateTime.now().toIso8601String(),
  });
  final p = await SharedPreferences.getInstance();

  LocalSettings.initialize(p);

  test('Primitive type: int', () async {
    expect(LocalSettings().primitiveInt.get(), isNull);

    final int valueA = 0x458;

    expect(await LocalSettings().primitiveInt.set(valueA), equals(valueA));
    expect(LocalSettings().primitiveInt.get(), equals(valueA));

    expect(
      await LocalSettings().primitiveInt.remove(),
      TypeMatcher<bool>(),
    ); // TODO Intention of return value from SharedPreferences.remove() is not documented.
    expect(LocalSettings().primitiveInt.get(), isNull);
  });
}
