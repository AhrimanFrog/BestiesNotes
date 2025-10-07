import 'rate.dart';
import 'roadmap.dart';

abstract class Teachable {
  String name;
  Rate pricing;
  String? iconPath;
  Roadmap roadmap = .new();

  Teachable({required this.name, required this.pricing, this.iconPath});

  String get initials => name
    .split(' ')
    .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
    .join();
}
