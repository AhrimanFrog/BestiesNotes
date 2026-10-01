import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/theme/app_tokens.dart';

extension LessonUIExt on Lesson {
  StatusTone get statusTone {
    if (isCancelled) return StatusTone.cancelled;
    if (isCompleted) return StatusTone.done;
    return isNow ? StatusTone.now : StatusTone.scheduled;
  }

  String get uiLabel {
    if (isCancelled) return 'Cancelled';
    if (isCompleted) return 'Completed';
    return isNow ? 'In progress' : 'Scheduled';
  }
}
