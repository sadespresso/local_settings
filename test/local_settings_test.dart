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
    )..init();
    themeMode = ThemeModeSettingsEntry(
      key: "themeMode",
      preferences: preferences,
    )..init();
    boolean1 = BoolSettingsEntry(
      key: "booleanTrue",
      preferences: preferences,
      initialValue: true,
    )..init();
    boolean2 = BoolSettingsEntry(
      key: "booleanFalse",
      preferences: preferences,
      initialValue: false,
    )..init();
    dateTime = DateTimeSettingsEntry(
      key: "dateTime",
      preferences: preferences,
    )..init();
    primitiveInt = PrimitiveSettingsEntry<int>(
      key: "primitiveInt",
      preferences: preferences,
    )..init();
    primitiveString = PrimitiveSettingsEntry<String>(
      key: "primitiveString",
      preferences: preferences,
    )..init();
    primitiveDouble = PrimitiveSettingsEntry<double>(
      key: "primitiveDouble",
      preferences: preferences,
    )..init();
    primitiveBool = PrimitiveSettingsEntry<bool>(
      key: "primitiveBool",
      preferences: preferences,
    )..init();
    primitiveListString = PrimitiveSettingsEntry<List<String>>(
      key: "primitiveListString",
      preferences: preferences,
    )..init();
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

  test('Initial value preservation', () async {
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
