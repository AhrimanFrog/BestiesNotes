import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_tokens.dart';

extension LessonUIExt on Lesson {
  StatusTone get statusTone {
    if (isCancelled) return StatusTone.cancelled;
    if (isCompleted) return StatusTone.done;
    return isNow ? StatusTone.now : StatusTone.scheduled;
  }

  String statusLabel(AppLocalizations l10n) {
    if (isCancelled) return l10n.lessonStatusCancelled;
    if (isCompleted) return l10n.lessonStatusCompleted;
    return isNow ? l10n.lessonStatusInProgress : l10n.lessonStatusScheduled;
  }

  /// "Anna", "Anna +2" — counts students and groups, not group members.
  String audienceLabel(AppLocalizations l10n) {
    final subjects = this.subjects;
    if (subjects.isEmpty) return l10n.lessonNoOneAssigned;
    final rest = subjects.length - 1;
    return rest > 0
        ? l10n.lessonAudienceMore(subjects.first.name, rest)
        : subjects.first.name;
  }
}
