import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/student.dart';
import 'package:besties_notes/data/ui_models/rate.dart';
import 'package:besties_notes/widgets/index.dart';

class StudentForm extends StatefulWidget {
  const StudentForm({super.key});

  @override
  State<StatefulWidget> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _rateController = TextEditingController();
  final _noteController = TextEditingController();

  RatePeriod _selectedPeriod = RatePeriod.daily;
  bool _isSubmitting = false;

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
        name: _nameController.text.trim(),
        contact: _contactController.text.trim(),
        pricing: Rate(
          rate: double.parse(_rateController.text),
          period: _selectedPeriod,
        ),
        note: _noteController.text.trim(),
      );
      await context.read<StudentsAndGroupsCubit>().createStudent(student);
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
              ModalHeaderRow(title: 'New Student', icon: Icons.person_add),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: [
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InputField(
                              _rateController,
                              label: 'Rate',
                              hint: '420',
                              icon: Icon(Icons.attach_money),
                              textInputType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              formatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*'),
                                ),
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a rate';
                                }
                                final rate = double.tryParse(value);
                                if (rate == null || rate <= 0) {
                                  return 'Please enter a valid rate';
                                }
                                return null;
                              },
                            ),
                          ),
                          Flexible(
                            child: DropdownButtonFormField<RatePeriod>(
                              initialValue: _selectedPeriod,
                              decoration: const InputDecoration(
                                labelText: 'Period',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: RatePeriod.daily,
                                  child: Text('Daily'),
                                ),
                                DropdownMenuItem(
                                  value: RatePeriod.monthly,
                                  child: Text('Monthly'),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedPeriod = val);
                                }
                              },
                            ),
                          ),
                        ],
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
                    : const Text(
                        'Create Student',
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
