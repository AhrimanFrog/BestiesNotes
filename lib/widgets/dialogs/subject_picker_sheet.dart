import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/avatar/user_avatar.dart';
import 'package:besties_notes/widgets/layout/empty_state.dart';
import 'package:flutter/material.dart';

/// Lets the user pick students and/or groups. Resolves to the new selection,
/// or null when dismissed without confirming.
Future<List<Teachable>?> showSubjectPicker(
  BuildContext context, {
  required String title,
  required List<Teachable> available,
  required Iterable<Teachable> selected,
}) {
  return showModalBottomSheet<List<Teachable>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: true,
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.9,
      child: SubjectPickerSheet(
        title: title,
        available: available,
        selected: selected,
      ),
    ),
  );
}

class SubjectPickerSheet extends StatefulWidget {
  final String title;
  final List<Teachable> available;
  final Iterable<Teachable> selected;

  const SubjectPickerSheet({
    super.key,
    required this.title,
    required this.available,
    required this.selected,
  });

  @override
  State<SubjectPickerSheet> createState() => _SubjectPickerSheetState();
}

class _SubjectPickerSheetState extends State<SubjectPickerSheet> {
  // Matched by type + id: the caller's objects may be different instances
  // (or stale copies) of the same student or group.
  late final Set<(Type, int?)> _selectedKeys = {
    for (final t in widget.selected) _key(t),
  };
  String _query = '';

  static (Type, int?) _key(Teachable t) => (t.runtimeType, t.id);

  List<Teachable> _matching<T extends Teachable>() {
    final q = _query.trim().toLowerCase();
    return widget.available
        .whereType<T>()
        .where((t) => q.isEmpty || t.name.toLowerCase().contains(q))
        .toList();
  }

  void _toggle(Teachable t) => setState(() {
    final key = _key(t);
    if (!_selectedKeys.remove(key)) _selectedKeys.add(key);
  });

  void _confirm() => Navigator.pop(context, [
    for (final t in widget.available)
      if (_selectedKeys.contains(_key(t))) t,
  ]);

  @override
  Widget build(BuildContext context) {
    final groups = _matching<Group>();
    final students = _matching<Student>();
    final count = _selectedKeys.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: context.textTheme.headlineSmall,
                ),
              ),
              FilledButton(
                onPressed: _confirm,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                ),
                child: Text(count == 0 ? 'Done' : 'Done ($count)'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            autofocus: false,
            onChanged: (value) => setState(() => _query = value),
            decoration: const InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: groups.isEmpty && students.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No matches',
                    compact: true,
                  )
                : ListView(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                    children: [
                      if (groups.isNotEmpty) ...[
                        const _Header('Groups'),
                        for (final g in groups) _tile(g),
                      ],
                      if (students.isNotEmpty) ...[
                        const _Header('Students'),
                        for (final s in students) _tile(s),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _tile(Teachable t) {
    final subtitle = switch (t) {
      Group(:final students) when students.isNotEmpty =>
        students.length == 1 ? '1 member' : '${students.length} members',
      Student(:final group?) => group.name,
      Student(:final contact) when contact.isNotEmpty => contact,
      _ => null,
    };
    return CheckboxListTile(
      value: _selectedKeys.contains(_key(t)),
      onChanged: (_) => _toggle(t),
      secondary: UserAvatar(teachable: t, size: 40),
      title: Text(t.name),
      subtitle: subtitle != null ? Text(subtitle) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
    );
  }
}

class _Header extends StatelessWidget {
  final String label;

  const _Header(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.lg,
        bottom: AppSpacing.xs,
        left: AppSpacing.xs,
      ),
      child: Text(label.toUpperCase(), style: context.textTheme.labelMedium),
    );
  }
}
