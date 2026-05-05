import 'package:besties_notes/data/ui_models/index.dart';

abstract class RecurringProvider {
  Future<List<RecurringTemplate>> getTemplates();

  Future<RecurringTemplate> getTemplate(int templateId);

  Future<int> createOrUpdateTemplate(RecurringTemplate template);

  Future<void> deleteTemplate(int templateId);

  Future<void> syncTemplateParticipants(int templateId, List<Teachable> subjects);

  /// Persists a specific template occurrence as a real lesson if it hasn't been
  /// materialized yet. Returns the lesson id.
  Future<int> materializeOccurrence(int templateId, DateTime occurrenceDate);
}
