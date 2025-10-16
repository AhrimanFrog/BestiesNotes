import 'package:besties_notes/providers/index.dart';

class ScheduleRepo<T extends DataProvider> {
  DataProvider dataProvider;

  ScheduleRepo({required this.dataProvider});
}
