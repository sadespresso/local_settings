import 'package:local_settings/src/entries/serialized.dart';
import 'package:local_settings/src/entries/serialized_list.dart';
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
  late final SerializedSettingsEntry<List<int>> serializedIntList;
  late final SerializedListSettingsEntry<List<int>> serializedListIntList;

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
    serializedIntList = SerializedSettingsEntry<List<int>>(
      key: "serializedIntList",
      preferences: preferences,
      serialize: (data) => data.join(","),
      deserialize: (serialized) =>
          serialized.split(",").map(int.parse).toList(),
    )..init();
    serializedListIntList = SerializedListSettingsEntry<List<int>>(
      key: "serializedListIntList",
      preferences: preferences,
      serialize: (data) => data.join(","),
      deserialize: (serialized) =>
          serialized.split(",").map(int.parse).toList(),
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

  test('Primitive type: String', () async {
    expect(LocalSettings().primitiveString.get(), isNull);

    final String valueA = "testString";

    expect(await LocalSettings().primitiveString.set(valueA), equals(valueA));
    expect(LocalSettings().primitiveString.get(), equals(valueA));

    expect(
      await LocalSettings().primitiveString.remove(),
      TypeMatcher<bool>(),
    );
    expect(LocalSettings().primitiveString.get(), isNull);
  });

  test('Primitive type: double', () async {
    expect(LocalSettings().primitiveDouble.get(), isNull);

    final double valueA = 123.456;

    expect(await LocalSettings().primitiveDouble.set(valueA), equals(valueA));
    expect(LocalSettings().primitiveDouble.get(), equals(valueA));

    expect(
      await LocalSettings().primitiveDouble.remove(),
      TypeMatcher<bool>(),
    );
    expect(LocalSettings().primitiveDouble.get(), isNull);
  });

  test('Primitive type: bool', () async {
    expect(LocalSettings().primitiveBool.get(), isNull);

    final bool valueA = true;

    expect(await LocalSettings().primitiveBool.set(valueA), equals(valueA));
    expect(LocalSettings().primitiveBool.get(), equals(valueA));

    expect(
      await LocalSettings().primitiveBool.remove(),
      TypeMatcher<bool>(),
    );
    expect(LocalSettings().primitiveBool.get(), isNull);
  });

  test('Primitive type: List<String>', () async {
    expect(LocalSettings().primitiveListString.get(), isNull);

    final List<String> valueA = ["one", "two", "three"];

    expect(
        await LocalSettings().primitiveListString.set(valueA), equals(valueA));
    expect(LocalSettings().primitiveListString.get(), equals(valueA));

    expect(
      await LocalSettings().primitiveListString.remove(),
      TypeMatcher<bool>(),
    );
    expect(LocalSettings().primitiveListString.get(), isNull);
  });

  test('Serialized type: List<int>', () async {
    expect(LocalSettings().serializedIntList.get(), isNull);

    final List<int> valueA = [1, 2, 3];

    expect(await LocalSettings().serializedIntList.set(valueA), equals(valueA));
    expect(LocalSettings().serializedIntList.get(), equals(valueA));

    expect(
      await LocalSettings().serializedIntList.remove(),
      TypeMatcher<bool>(),
    );
    expect(LocalSettings().serializedIntList.get(), isNull);
  });

  test('SerializedList type: List<int>', () async {
    expect(LocalSettings().serializedListIntList.get(), isNull);

    final List<List<int>> valueA = [[4, 5, 6], [1, 23, 5, 7]];

    expect(await LocalSettings().serializedListIntList.set(valueA),
        equals(valueA));
    expect(LocalSettings().serializedListIntList.get(), equals(valueA));

    expect(
      await LocalSettings().serializedListIntList.remove(),
      TypeMatcher<bool>(),
    );
    expect(LocalSettings().serializedListIntList.get(), isNull);
  });
}
