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

mixin ListEntry<T> on SettingsEntry<List<T>> {
  Set<T>? get asSet => get()?.toSet();

  /// Adds [item] and calls [set]
  Future<void> addItem(T item) async {
    final List<T> list = get() ?? [];

    list.add(item);

    await set(list);
  }

  /// Adds all entries in [items] and
  /// calls [set]
  Future<void> addAll(List<T> items) async {
    final List<T> list = get() ?? [];

    list.addAll(items);

    await set(list);
  }

  /// Removes [item], and returns whether the
  /// element was removed
  Future<bool> removeItem(T item) async {
    final List<T> list = get() ?? [];
    if (list.isEmpty) return false;

    final removed = list.remove(item);

    await set(list);
    return removed;
  }

  /// Removes all [items] from [this]
  Future<void> removeMultiple(List<T> items) =>
      removeWhere((element) => items.contains(element));

  /// Deletes every element in this list
  Future<void> clear() => set([]);

  Future<void> removeWhere(PredicateFn<T> predicate) async {
    final list = get() ?? [];
    if (list.isEmpty) return;

    list.removeWhere(predicate);
    await set(list);
  }

  Future<void> retainWhere(PredicateFn<T> predicate) async {
    final list = get() ?? [];
    if (list.isEmpty) return;

    list.retainWhere(predicate);
    await set(list);
  }
}
