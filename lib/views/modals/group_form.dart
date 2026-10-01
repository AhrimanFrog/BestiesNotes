import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/index.dart';

class GroupForm extends StatefulWidget {
  final Group? group;

  const GroupForm(this.group, {super.key});

  @override
  State<StatefulWidget> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _rateController;

  late RatePeriod _selectedPeriod;
  bool _isSubmitting = false;
  bool _isLoadingMembers = false;
  String? _avatarPath;
  Set<Student> _selectedStudents = {};

  Group? get group => widget.group;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: group?.name);
    _rateController = TextEditingController(
      text: group?.pricing.rate.toString() ?? '',
    );
    _selectedPeriod = group?.pricing.period ?? RatePeriod.perLesson;
    _avatarPath = group?.iconPath;

    if (group?.id != null) {
      _loadMembers();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  Future<void> _loadMembers() async {
    setState(() => _isLoadingMembers = true);
    try {
      final cubit = context.read<StudentsAndGroupsCubit>();
      await cubit.fetchGroupMembers(group!.id!);
      if (mounted) setState(() => _selectedStudents = cubit.state.groupMembers);
    } finally {
      if (mounted) setState(() => _isLoadingMembers = false);
    }
  }

  Future<void> _selectStudents() async {
    final cubit = context.read<StudentsAndGroupsCubit>();
    final allStudents = cubit.state.students;

    if (allStudents.isEmpty) {
      showInfoSnackBar(context, 'No students yet. Add some first.');
      return;
    }

    final selected = await showSubjectPicker(
      context,
      title: 'Members',
      available: allStudents,
      selected: _selectedStudents,
    );

    if (selected != null) {
      setState(() => _selectedStudents = selected.cast<Student>().toSet());
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedStudents.isEmpty) {
      showErrorSnackBar(context, 'Add at least one student to the group');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final group = Group(
        id: this.group?.id,
        name: _nameController.text.trim(),
        pricing: Rate(
          rate: Rate.tryParseAmount(_rateController.text)!,
          period: _selectedPeriod,
        ),
        iconPath: _avatarPath,
        students: _selectedStudents,
      );
      final cubit = context.read<StudentsAndGroupsCubit>();
      await cubit.createOrUpdateGroup(group);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, 'Could not save group: $e');
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
                title: group != null ? 'Edit group' : 'New group',
                icon: group != null
                    ? Icons.edit_outlined
                    : Icons.group_add_outlined,
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
                        defaultIcon: Icons.groups_outlined,
                        onChanged: (path) => setState(() => _avatarPath = path),
                      ),
                      InputField(
                        _nameController,
                        label: 'Group name',
                        hint: 'Enter group name',
                        icon: const Icon(Icons.groups_outlined),
                      ),
                      RatePeriodField(
                        rateController: _rateController,
                        selectedPeriod: _selectedPeriod,
                        onPeriodChanged: (val) =>
                            setState(() => _selectedPeriod = val),
                      ),
                      ScholarsSelector(
                        label: 'Members',
                        selectedSubjects: _selectedStudents,
                        onTap: _isLoadingMembers ? null : _selectStudents,
                        onDeleted: (s) => setState(() {
                          _selectedStudents = Set.from(_selectedStudents)
                            ..remove(s);
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              SubmitButton(
                label: group != null ? 'Save changes' : 'Create group',
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
