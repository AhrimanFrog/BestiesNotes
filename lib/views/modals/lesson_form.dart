import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/widgets/index.dart';

class LessonForm extends StatefulWidget {
  final Lesson? lesson;

  const LessonForm(this.lesson, {super.key});

  @override
  State<StatefulWidget> createState() => _LessonFormState();
}

class _LessonFormState extends State<LessonForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _durationController;
  late final TextEditingController _noteController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late List<Teachable> _selectedSubjects;
  bool _isSubmitting = false;

  Lesson? get lesson => widget.lesson;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: lesson?.name);
    _durationController = TextEditingController(
      text: "${lesson?.duration.inMinutes ?? 60}",
    );
    _noteController = TextEditingController(text: lesson?.note);
    _selectedDate = lesson?.start ?? DateTime.now();
    _selectedTime = TimeOfDay.fromDateTime(lesson?.start ?? DateTime.now());
    _selectedSubjects = lesson?.subjects ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _selectSubjects() async {
    final studentsAndGroupsCubit = context.read<StudentsAndGroupsCubit>();
    final students = studentsAndGroupsCubit.state.students;
    final groups = studentsAndGroupsCubit.state.groups;
    final allTeachables = [...students, ...groups];

    if (allTeachables.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No students or groups available. Create some first.'),
        ),
      );
      return;
    }

    final selected = await showDialog<List<Teachable>>(
      context: context,
      builder: (context) => TeachableSelectionDialog(
        title: 'Select Students / Groups',
        available: allTeachables,
        selected: _selectedSubjects,
      ),
    );

    if (selected != null) {
      setState(() => _selectedSubjects = selected);
    }
  }

  Future<void> _cancelLesson() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Cancel this lesson?',
      message: 'It stays in the schedule, marked as cancelled.',
      confirmLabel: 'Cancel lesson',
      cancelLabel: 'Keep it',
      destructive: true,
    );

    if (!confirmed || !mounted) return;
    setState(() => _isSubmitting = true);

    try {
      final cubit = context.read<LessonsCubit>();
      await cubit.cancelLesson(lesson!.id!);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, 'Could not cancel lesson: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSubjects.isEmpty) {
      showErrorSnackBar(context, 'Pick at least one student or group');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final startDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final lesson = Lesson(
        id: this.lesson?.id,
        name: _nameController.text.trim(),
        start: startDateTime,
        duration: Duration(minutes: int.parse(_durationController.text)),
        note: _noteController.text.trim(),
        isCancelled: this.lesson?.isCancelled ?? false,
      );

      final cubit = context.read<LessonsCubit>();
      await cubit.createOrUpdateLesson(lesson, _selectedSubjects);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, 'Could not save lesson: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xxl,
          0,
          AppSpacing.xxl,
          AppSpacing.xxl,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.lg,
            children: [
              ModalHeaderRow(
                title: lesson != null ? 'Edit lesson' : 'New lesson',
                icon: lesson != null
                    ? Icons.edit_outlined
                    : Icons.event_available_outlined,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: AppSpacing.lg,
                    children: [
                      InputField(
                        _nameController,
                        label: 'Topic',
                        hint: 'E.g. Present Simple',
                        icon: const Icon(Icons.menu_book_outlined),
                      ),
                      ScholarsSelector(
                        label: 'Students / Groups',
                        selectedSubjects: _selectedSubjects,
                        onTap: _selectSubjects,
                        onDeleted: (s) => setState(() {
                          _selectedSubjects = _selectedSubjects
                              .where((t) => t != s)
                              .toList();
                        }),
                      ),
                      Row(
                        spacing: AppSpacing.md,
                        children: [
                          Expanded(
                            child: InkWellSelector(
                              title: 'Date',
                              body: _selectedDate.toDateFormat(),
                              icon: Icons.calendar_today_outlined,
                              onTap: _selectDate,
                            ),
                          ),
                          Expanded(
                            child: InkWellSelector(
                              title: 'Time',
                              body: _selectedTime.format(context),
                              icon: Icons.schedule_outlined,
                              onTap: _selectTime,
                            ),
                          ),
                        ],
                      ),
                      InputField(
                        _durationController,
                        label: 'Duration (minutes)',
                        hint: '60',
                        icon: const Icon(Icons.timer_outlined),
                        textInputType: TextInputType.number,
                        formatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter duration';
                          }
                          final duration = int.tryParse(value);
                          if (duration == null || duration <= 0) {
                            return 'Please enter a valid duration';
                          }
                          return null;
                        },
                      ),
                      InputField(
                        _noteController,
                        label: 'Notes (optional)',
                        icon: const Icon(Icons.notes_outlined),
                        validator: (_) => null,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              SubmitButton(
                label: lesson != null ? 'Save changes' : 'Create lesson',
                isSubmitting: _isSubmitting,
                onPressed: _submitForm,
              ),
              if (lesson != null && !lesson!.isCancelled)
                OutlinedButton(
                  onPressed: _isSubmitting ? null : _cancelLesson,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.tokens.danger,
                  ),
                  child: const Text('Cancel lesson'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
