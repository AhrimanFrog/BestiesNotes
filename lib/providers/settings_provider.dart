/// Persists app preferences as string key/value pairs.
abstract class SettingsProvider {
  Future<Map<String, String>> loadSettings();

  /// Upserts the given entries; other keys are left alone.
  Future<void> saveSettings(Map<String, String> values);
}
