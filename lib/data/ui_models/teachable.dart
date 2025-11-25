import 'rate.dart';

abstract class Teachable {
  int? id;
  String name;
  Rate pricing;
  String? iconPath;

  Teachable({
    this.id,
    required this.name,
    required this.pricing,
    this.iconPath,
  });

  String get initials => name
      .split(' ')
      .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
      .join();
}
