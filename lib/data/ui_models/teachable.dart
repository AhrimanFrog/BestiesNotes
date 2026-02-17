import 'rate.dart';

abstract class Teachable {
  final int? id;
  final String name;
  final Rate pricing;
  final String? iconPath;

  const Teachable({
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
