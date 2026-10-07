import 'package:besties_notes/data/app_settings.dart';
import 'package:besties_notes/providers/settings_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// App-wide preferences. Starts from the settings loaded before the app
/// launched, so the first frame already has the right language and week.
class SettingsCubit extends Cubit<AppSettings> {
  final SettingsProvider _provider;

  SettingsCubit(this._provider, [super.initial = const AppSettings()]);

  /// Applies [change] immediately and persists the keys that changed.
  Future<void> update(AppSettings Function(AppSettings s) change) async {
    final before = state;
    final after = change(before);
    if (after == before) return;
    emit(after);

    final old = before.toMap();
    final changed = {
      for (final MapEntry(:key, :value) in after.toMap().entries)
        if (old[key] != value) key: value,
    };
    try {
      await _provider.saveSettings(changed);
    } catch (_) {
      // Keep the screen honest: undo what couldn't be stored.
      emit(before);
      rethrow;
    }
  }
}
