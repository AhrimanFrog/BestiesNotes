import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/index.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'recurring_state.dart';

class RecurringCubit extends Cubit<RecurringState> {
  final RecurringProvider _provider;

  RecurringCubit(this._provider) : super(const RecurringState());

  Future<void> fetchTemplates() async {
    emit(state.copyWith(isLoading: true, error: () => null));
    try {
      final templates = await _provider.getTemplates();
      emit(state.copyWith(templates: templates, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: () => e.toString()));
    }
  }

  Future<void> createOrUpdateTemplate(
    RecurringTemplate template,
    List<Teachable> subjects,
  ) async {
    final id = await _provider.createOrUpdateTemplate(template);
    await _provider.syncTemplateParticipants(id, subjects);
    await fetchTemplates();
  }

  Future<void> deleteTemplate(int templateId) async {
    await _provider.deleteTemplate(templateId);
    await fetchTemplates();
  }
}
