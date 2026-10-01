import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/student.dart';
import 'package:besties_notes/data/ui_models/rate.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/index.dart';

class StudentForm extends StatefulWidget {
  final Student? student;

  const StudentForm(this.student, {super.key});

  @override
  State<StatefulWidget> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _contactController;
  late final TextEditingController _rateController;
  late final TextEditingController _noteController;

  late RatePeriod _selectedPeriod;
  bool _isSubmitting = false;
  String? _avatarPath;

  Student? get student => widget.student;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: student?.name);
    _contactController = TextEditingController(text: student?.contact);
    _rateController = TextEditingController(
      text: student?.pricing.rate.toString() ?? '',
    );
    _noteController = TextEditingController(text: student?.note);
    _selectedPeriod = student?.pricing.period ?? .perLesson;
    _avatarPath = student?.iconPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _rateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final student = Student(
        id: this.student?.id,
        name: _nameController.text.trim(),
        contact: _contactController.text.trim(),
        pricing: Rate(
          rate: Rate.tryParseAmount(_rateController.text)!,
          period: _selectedPeriod,
        ),
        note: _noteController.text.trim(),
        iconPath: _avatarPath,
        // Membership is edited from the group form; keep it unchanged here.
        group: this.student?.group,
      );
      final cubit = context.read<StudentsAndGroupsCubit>();
      await cubit.createOrUpdateStudent(student);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, 'Could not save student: $e');
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
                title: student != null ? 'Edit student' : 'New student',
                icon: student != null
                    ? Icons.edit_outlined
                    : Icons.person_add_outlined,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: AppSpacing.lg,
                    children: [
                      AvatarPickerField(
                        avatarPath: _avatarPath,
                        defaultIcon: Icons.person_outline_rounded,
                        onChanged: (path) => setState(() => _avatarPath = path),
                      ),
                      InputField(
                        _nameController,
                        label: 'Name',
                        hint: 'Enter student name',
                        icon: const Icon(Icons.person_outline_rounded),
                      ),
                      InputField(
                        _contactController,
                        label: 'Contact',
                        hint: 'Phone number or messenger handle',
                        icon: const Icon(Icons.phone_outlined),
                      ),
                      RatePeriodField(
                        rateController: _rateController,
                        selectedPeriod: _selectedPeriod,
                        onPeriodChanged: (val) =>
                            setState(() => _selectedPeriod = val),
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
                label: student != null ? 'Save changes' : 'Add student',
                isSubmitting: _isSubmitting,
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
