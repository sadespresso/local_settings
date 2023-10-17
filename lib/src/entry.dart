import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsEntry<T> {
  final String key;
  final SharedPreferences preferences;

  final ValueNotifier<T?> valueNotifier = ValueNotifier(null);

  final T? initialValue;

  void Function(VoidCallback) get addListener => valueNotifier.addListener;
  void Function(VoidCallback) get removeListener =>
      valueNotifier.removeListener;

  SettingsEntry({
    required this.key,
    required this.preferences,
    this.initialValue,
  }) {
    valueNotifier.value = get();
  }

  Future<void> init() async {
    if (initialValue != null && !preferences.containsKey(key)) {
      await set(initialValue as T);
    }
  }

  /// Retreives value, may be null
  T? get();

  /// Synonym for [get()]
  T? get value => get();

  /// Saves data to SharedPreferences
  ///
  /// Use [remove] for deleting the value
  Future<T> set(T data);

  /// Deletes entry from SharedPreferences
  Future<bool> remove() async {
    valueNotifier.value = null;
    return await preferences.remove(key);
  }

  /// Sets value to [initialValue]
  ///
  /// If [initialValue] is null, removes the entry
  Future<T?> reset() async {
    if (initialValue != null) {
      await set(initialValue as T);
    } else {
      await remove();
    }
    return null;
  }
}

typedef PredicateFn<T> = bool Function(T element);

mixin ListEntry<T> on SettingsEntry<T> {
  Future<List<T>> addItem(T item);
  Future<List<T>> addAll(List<T> items);

  /// Removes [item], and returns the element if
  /// it was existed in the list.
  Future<T?> removeItem(T item);

  /// Deletes every element in this list
  Future<void> removeAll();

  /// Deletes every element in this list
  Future<void> clear() => removeAll();

  /// Returns the first matched element.
  T? firstWhere(PredicateFn<T> predicate);

  Future<List<T>> where(PredicateFn<T> predicate);

  Future<void> removeWhere(PredicateFn<T> predicate);
  Future<void> retainWhere(PredicateFn<T> predicate);
}
