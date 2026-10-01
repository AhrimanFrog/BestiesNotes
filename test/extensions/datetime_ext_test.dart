import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('startOfWeek', () {
    // 2025-01-08 is a Wednesday.
    final wednesday = DateTime(2025, 1, 8, 15, 30);

    test('Monday start', () {
      expect(wednesday.startOfWeek(DateTime.monday), DateTime(2025, 1, 6));
    });

    test('Sunday start', () {
      expect(wednesday.startOfWeek(DateTime.sunday), DateTime(2025, 1, 5));
    });

    test('a week-start day maps to itself', () {
      expect(
        DateTime(2025, 1, 6, 9).startOfWeek(DateTime.monday),
        DateTime(2025, 1, 6),
      );
    });
  });

  test('addDays keeps midnight across month ends', () {
    expect(DateTime(2025, 1, 29).addDays(7), DateTime(2025, 2, 5));
    expect(DateTime(2025, 3, 3).addDays(-7), DateTime(2025, 2, 24));
  });
}
