import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/common/app_colors.dart';
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

  Future<void> _pickAvatar() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            if (_avatarPath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  setState(() => _avatarPath = null);
                  Navigator.pop(ctx);
                },
              ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (picked == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final ext = p.extension(picked.path);
    final savedPath = p.join(appDir.path, 'avatars', '${DateTime.now().millisecondsSinceEpoch}$ext');
    await Directory(p.dirname(savedPath)).create(recursive: true);
    await File(picked.path).copy(savedPath);

    setState(() => _avatarPath = savedPath);
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
                      Center(
                        child: GestureDetector(
                          onTap: _pickAvatar,
                          child: Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.accentPink, width: 2),
                                  color: AppColors.softWarmPink,
                                ),
                                child: _avatarPath != null
                                    ? ClipOval(
                                        child: Image.file(
                                          File(_avatarPath!),
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(Icons.person, size: 40, color: AppColors.accentPink),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.accentPink,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
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
