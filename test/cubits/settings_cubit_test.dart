import 'package:besties_notes/cubits/settings/settings_cubit.dart';
import 'package:besties_notes/data/app_settings.dart';
import 'package:besties_notes/providers/settings_provider.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsProvider extends Mock implements SettingsProvider {}

void main() {
  late MockSettingsProvider provider;

  setUp(() {
    provider = MockSettingsProvider();
    when(() => provider.saveSettings(any())).thenAnswer((_) async {});
  });

  blocTest<SettingsCubit, AppSettings>(
    'update applies the change and stores only the changed keys',
    build: () => SettingsCubit(provider),
    act: (c) => c.update((s) => s.copyWith(weekStart: DateTime.sunday)),
    expect: () => [const AppSettings(weekStart: DateTime.sunday)],
    verify: (_) =>
        verify(() => provider.saveSettings({'week_start': '7'})).called(1),
  );

  blocTest<SettingsCubit, AppSettings>(
    'a no-op update emits and stores nothing',
    build: () => SettingsCubit(provider),
    act: (c) => c.update((s) => s.copyWith(defaultLessonMinutes: 60)),
    expect: () => [],
    verify: (_) => verifyNever(() => provider.saveSettings(any())),
  );

  blocTest<SettingsCubit, AppSettings>(
    'a failed save reverts so the screen matches what is stored',
    build: () => SettingsCubit(provider),
    setUp: () => when(
      () => provider.saveSettings(any()),
    ).thenThrow(Exception('disk full')),
    act: (c) async {
      try {
        await c.update((s) => s.copyWith(currency: () => 'UAH'));
      } catch (_) {}
    },
    expect: () => [const AppSettings(currency: 'UAH'), const AppSettings()],
  );
}
