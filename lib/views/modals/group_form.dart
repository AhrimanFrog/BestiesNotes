import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
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
    _selectedPeriod = group?.pricing.period ?? RatePeriod.daily;
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No students available. Create some first.'),
        ),
      );
      return;
    }

    final selected = await showDialog<List<Teachable>>(
      context: context,
      builder: (context) => TeachableSelectionDialog(
        title: 'Select Students',
        available: allStudents,
        selected: _selectedStudents,
      ),
    );

    if (selected != null) {
      setState(() => _selectedStudents = selected.cast<Student>().toSet());
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final group = Group(
        id: this.group?.id,
        name: _nameController.text.trim(),
        pricing: Rate(
          rate: double.parse(_rateController.text),
          period: _selectedPeriod,
        ),
        iconPath: _avatarPath,
        students: _selectedStudents,
      );
      final cubit = context.read<StudentsAndGroupsCubit>();
      await cubit.createOrUpdateGroup(group);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving group: $e'),
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
                title: group != null ? 'Edit Group' : 'New Group',
                icon: group != null ? Icons.edit : Icons.group_add,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: [
                      AvatarPickerField(
                        avatarPath: _avatarPath,
                        defaultIcon: Icons.groups,
                        onChanged: (path) => setState(() => _avatarPath = path),
                      ),
                      InputField(
                        _nameController,
                        label: 'Group Name',
                        hint: 'Enter group name',
                        icon: const Icon(Icons.groups),
                      ),
                      RatePeriodField(
                        rateController: _rateController,
                        selectedPeriod: _selectedPeriod,
                        onPeriodChanged: (val) =>
                            setState(() => _selectedPeriod = val),
                      ),
                      _buildStudentSelector(),
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
                        group != null ? 'Update Group' : 'Create Group',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentSelector() {
    return InkWell(
      onTap: _isLoadingMembers ? null : _selectStudents,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Members',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.people),
        ),
        child: _isLoadingMembers
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : _selectedStudents.isEmpty
            ? const Text(
                'Tap to select students',
                style: TextStyle(color: Colors.grey),
              )
            : Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _selectedStudents
                    .map(
                      (s) => Chip(
                        label: Text(s.name),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          setState(() {
                            _selectedStudents = Set.from(_selectedStudents)
                              ..remove(s);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
