import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/cubits/recurring/recurring_cubit.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecurringTemplateForm extends StatefulWidget {
  final RecurringTemplate? template;

  const RecurringTemplateForm(this.template, {super.key});

  @override
  State<RecurringTemplateForm> createState() => _RecurringTemplateFormState();
}

class _RecurringTemplateFormState extends State<RecurringTemplateForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _durationController;
  late final TextEditingController _noteController;

  late int _dayOfWeek;
  late TimeOfDay _startTime;
  late DateTime _startDate;
  DateTime? _endDate;
  late List<Teachable> _selectedSubjects;
  bool _isSubmitting = false;

  RecurringTemplate? get template => widget.template;

  static const _weekdays = [
    (label: 'Mon', value: DateTime.monday),
    (label: 'Tue', value: DateTime.tuesday),
    (label: 'Wed', value: DateTime.wednesday),
    (label: 'Thu', value: DateTime.thursday),
    (label: 'Fri', value: DateTime.friday),
    (label: 'Sat', value: DateTime.saturday),
    (label: 'Sun', value: DateTime.sunday),
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: template?.name);
    _durationController = TextEditingController(
      text: '${template?.duration.inMinutes ?? 60}',
    );
    _noteController = TextEditingController(text: template?.note);
    _dayOfWeek = template?.dayOfWeek ?? DateTime.monday;
    _startTime = template != null
        ? TimeOfDay(hour: template!.startHour, minute: template!.startMinute)
        : TimeOfDay.now();
    _startDate = template?.startDate ?? DateTime.now();
    _endDate = template?.endDate;
    _selectedSubjects = template?.subjects ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate.add(const Duration(days: 90)),
      firstDate: _startDate,
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  Future<void> _selectSubjects() async {
    final cubit = context.read<StudentsAndGroupsCubit>();
    final allTeachables = [...cubit.state.students, ...cubit.state.groups];

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
      builder: (_) => TeachableSelectionDialog(
        title: 'Select Students / Groups',
        available: allTeachables,
        selected: _selectedSubjects,
      ),
    );

    if (selected != null) setState(() => _selectedSubjects = selected);
  }

  Future<void> _submit() async {
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
      final updated = RecurringTemplate(
        id: template?.id,
        name: _nameController.text.trim(),
        dayOfWeek: _dayOfWeek,
        startHour: _startTime.hour,
        startMinute: _startTime.minute,
        duration: Duration(minutes: int.parse(_durationController.text)),
        note: _noteController.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
      );

      await context
          .read<RecurringCubit>()
          .createOrUpdateTemplate(updated, _selectedSubjects);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving template: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Recurring Lesson'),
        content: const Text(
          'This will stop generating future occurrences. '
          'Past lessons are kept.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accentPink,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    setState(() => _isSubmitting = true);
    try {
      await context.read<RecurringCubit>().deleteTemplate(template!.id!);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 24,
            children: [
              ModalHeaderRow(
                title: template != null
                    ? 'Edit Recurring Lesson'
                    : 'New Recurring Lesson',
                icon: Icons.repeat,
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
                        hint: 'E.g. Grammar',
                        icon: const Icon(Icons.book),
                      ),
                      ScholarsSelector(
                        label: 'Students / Groups',
                        selectedSubjects: _selectedSubjects,
                        onTap: _selectSubjects,
                        onDeleted: (s) => setState(() {
                          _selectedSubjects =
                              _selectedSubjects.where((t) => t != s).toList();
                        }),
                      ),
                      _DayOfWeekPicker(
                        selected: _dayOfWeek,
                        onChanged: (d) => setState(() => _dayOfWeek = d),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWellSelector(
                              title: 'Start time',
                              body: _startTime.format(context),
                              icon: Icons.access_time,
                              onTap: _selectTime,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InputField(
                              _durationController,
                              label: 'Duration (min)',
                              hint: '60',
                              icon: const Icon(Icons.timer),
                              textInputType: TextInputType.number,
                              formatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (v) {
                                final d = int.tryParse(v ?? '');
                                if (d == null || d <= 0) {
                                  return 'Enter valid duration';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWellSelector(
                              title: 'Starts on',
                              body: _startDate.toDateFormat(),
                              icon: Icons.calendar_today,
                              onTap: _selectStartDate,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWellSelector(
                              title: 'Ends on (optional)',
                              body: _endDate?.toDateFormat() ?? 'No end date',
                              icon: Icons.event_busy,
                              onTap: _selectEndDate,
                            ),
                          ),
                        ],
                      ),
                      if (_endDate != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () => setState(() => _endDate = null),
                            icon: const Icon(Icons.close, size: 16),
                            label: const Text('Remove end date'),
                          ),
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
                onPressed: _isSubmitting ? null : _submit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        template != null ? 'Update' : 'Create',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
              if (template != null)
                OutlinedButton(
                  onPressed: _isSubmitting ? null : _delete,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: AppColors.accentPink,
                    side: const BorderSide(color: AppColors.accentPink),
                  ),
                  child: const Text(
                    'Delete Recurring Lesson',
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

class _DayOfWeekPicker extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  static const _days = [
    (label: 'Mo', value: DateTime.monday),
    (label: 'Tu', value: DateTime.tuesday),
    (label: 'We', value: DateTime.wednesday),
    (label: 'Th', value: DateTime.thursday),
    (label: 'Fr', value: DateTime.friday),
    (label: 'Sa', value: DateTime.saturday),
    (label: 'Su', value: DateTime.sunday),
  ];

  const _DayOfWeekPicker({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          'Day of week',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _days.map((d) {
            final isSelected = d.value == selected;
            return GestureDetector(
              onTap: () => onChanged(d.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? accent
                      : accent.withValues(alpha: 0.08),
                ),
                alignment: Alignment.center,
                child: Text(
                  d.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.mainText,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
