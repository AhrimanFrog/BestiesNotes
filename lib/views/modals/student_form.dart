import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/student.dart';
import 'package:besties_notes/data/ui_models/rate.dart';
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
    _rateController = TextEditingController(text: "${student?.pricing.rate}");
    _noteController = TextEditingController(text: student?.note);
    _selectedPeriod = student?.pricing.period ?? .daily;
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
          rate: double.parse(_rateController.text),
          period: _selectedPeriod,
        ),
        note: _noteController.text.trim(),
        iconPath: _avatarPath,
      );
      final cubit = context.read<StudentsAndGroupsCubit>();
      await cubit.createOrUpdateStudent(student);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating student: $e'),
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
                title: student != null ? 'Edit Student' : 'New Student',
                icon: student != null ? Icons.edit : Icons.person_add,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: [
                      AvatarPickerField(
                        avatarPath: _avatarPath,
                        defaultIcon: Icons.person,
                        onChanged: (path) => setState(() => _avatarPath = path),
                      ),
                      InputField(
                        _nameController,
                        label: 'Name',
                        hint: 'Enter student name',
                        icon: Icon(Icons.person),
                      ),
                      InputField(
                        _contactController,
                        label: 'Contact',
                        hint: 'E.g. phone number or tag in messanger',
                        icon: Icon(Icons.phone),
                      ),
                      RatePeriodField(
                        rateController: _rateController,
                        selectedPeriod: _selectedPeriod,
                        onPeriodChanged: (val) => setState(() => _selectedPeriod = val),
                      ),
                      InputField(
                        _noteController,
                        label: 'Notes (Optional)',
                        icon: Icon(Icons.notes),
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
                        student != null ? 'Update Student' : 'Create Student',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
