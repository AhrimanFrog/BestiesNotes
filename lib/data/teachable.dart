import 'rate.dart';
import 'roadmap.dart';
import 'level.dart';


abstract class Teachable {
  String name;
  String iconPath;
  Rate pricing;
  Level level;
  Roadmap roadmap = .new();

  Teachable({required this.name, required this.iconPath, Rate? pricing, Level? level})
    : pricing = pricing ?? Rate(rate: 0, period: .daily),
    level = level ?? .c1;
}
