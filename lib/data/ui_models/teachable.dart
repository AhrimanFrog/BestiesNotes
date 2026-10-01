import 'package:equatable/equatable.dart';

import 'rate.dart';

abstract class Teachable extends Equatable {
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

  /// Equatable 3 no longer compares runtimeType, so keep a Student and a Group
  /// with identical base fields from being equal.
  @override
  List<Object?> get props => [runtimeType, id, name, pricing, iconPath];
}
