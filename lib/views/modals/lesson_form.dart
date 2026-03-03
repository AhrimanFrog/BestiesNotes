import 'package:besties_notes/common/app_colors.dart';
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
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Lesson'),
        content: const Text('Are you sure you want to cancel this lesson?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accentPink,
            ),
            child: const Text('Yes, cancel it'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    setState(() => _isSubmitting = true);

    try {
      final cubit = context.read<LessonsCubit>();
      await cubit.cancelLesson(lesson!.id!);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cancelling lesson: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSubjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one student or group'),
          backgroundColor: Colors.red,
        ),
      );
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
        subjects: _selectedSubjects,
        start: startDateTime,
        duration: Duration(minutes: int.parse(_durationController.text)),
        note: _noteController.text.trim(),
      );

      final cubit = context.read<LessonsCubit>();
      await cubit.createOrUpdateLesson(lesson);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving lesson: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 24,
            children: [
              ModalHeaderRow(
                title: lesson != null ? 'Edit Lesson' : 'New Lesson',
                icon: lesson != null ? Icons.edit : Icons.add_box,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: [
                      InputField(
                        _nameController,
                        label: 'Lesson Name',
                        hint: 'E.g. Present Simple',
                        icon: const Icon(Icons.book),
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
                        children: [
                          Expanded(
                            child: InkWellSelector(
                              title: 'Date',
                              body:
                                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              onTap: _selectDate,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWellSelector(
                              title: 'Time',
                              body: _selectedTime.format(context),
                              onTap: _selectTime,
                            ),
                          ),
                        ],
                      ),
                      InputField(
                        _durationController,
                        label: 'Duration (minutes)',
                        hint: '60',
                        icon: const Icon(Icons.timer),
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
                        label: 'Notes (Optional)',
                        icon: const Icon(Icons.notes),
                        validator: (_) => null,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              FilledButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        lesson != null ? 'Update Lesson' : 'Create Lesson',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
              if (lesson != null && !lesson!.isCancelled)
                OutlinedButton(
                  onPressed: _isSubmitting ? null : _cancelLesson,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: AppColors.accentPink,
                    side: const BorderSide(color: AppColors.accentPink),
                  ),
                  child: const Text(
                    'Cancel Lesson',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
