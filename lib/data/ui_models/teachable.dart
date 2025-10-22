import 'rate.dart';

abstract class Teachable {
  String name;
  Rate pricing;
  String? iconPath;

  Teachable({required this.name, required this.pricing, this.iconPath});

  String get initials => name
      .split(' ')
      .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
      .join();
}
