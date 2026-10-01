import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/buttons/save_bar.dart';
import 'package:besties_notes/widgets/layout/empty_state.dart';
import 'package:besties_notes/widgets/layout/unsaved_changes_scope.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// An entry in a detail screen's overflow menu.
class DetailMenuAction {
  final IconData icon;
  final String label;
  final VoidCallback onSelected;
  final bool destructive;

  const DetailMenuAction({
    required this.icon,
    required this.label,
    required this.onSelected,
    this.destructive = false,
  });
}

/// The shared shape of lesson / student / group screens:
/// - view mode: content, an "Edit" FAB in thumb reach, rarer actions in the
///   overflow menu;
/// - edit mode (also how new items are created): a form with a sticky
///   Discard / Save bar, guarded against losing unsaved changes;
/// - loading and not-found states.
class DetailScaffold extends StatelessWidget {
  /// Lowercase noun for titles: "New lesson", "Edit lesson".
  final String noun;

  /// The saved item is loaded (false while loading or when creating).
  final bool isLoaded;
  final bool loadFailed;
  final bool isEditing;
  final bool isNew;
  final bool isDirty;
  final bool isSaving;

  final VoidCallback onEdit;
  final Future<bool> Function() onSave;
  final VoidCallback onDiscard;
  final List<DetailMenuAction> menuActions;

  final WidgetBuilder viewBuilder;
  final WidgetBuilder editBuilder;

  const DetailScaffold({
    super.key,
    required this.noun,
    required this.isLoaded,
    required this.loadFailed,
    required this.isEditing,
    required this.isNew,
    required this.isDirty,
    required this.isSaving,
    required this.onEdit,
    required this.onSave,
    required this.onDiscard,
    required this.viewBuilder,
    required this.editBuilder,
    this.menuActions = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (!isEditing && !isLoaded) {
      return Scaffold(
        appBar: AppBar(),
        body: loadFailed
            ? EmptyState(
                icon: Icons.error_outline_rounded,
                title: 'Not found',
                message: 'This $noun may have been deleted.',
                actionLabel: 'Back',
                onAction: () => context.pop(),
              )
            : const Center(child: CircularProgressIndicator()),
      );
    }

    return UnsavedChangesScope(
      isEditing: isEditing,
      isDirty: isDirty,
      onSave: onSave,
      onDiscard: onDiscard,
      child: isEditing ? _editMode(context) : _viewMode(context),
    );
  }

  Widget _viewMode(BuildContext context) {
    final danger = context.tokens.danger;
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (menuActions.isNotEmpty)
            PopupMenuButton<DetailMenuAction>(
              tooltip: 'More',
              onSelected: (action) => action.onSelected(),
              itemBuilder: (_) => [
                for (final action in menuActions)
                  PopupMenuItem(
                    value: action,
                    child: ListTile(
                      leading: Icon(
                        action.icon,
                        color: action.destructive ? danger : null,
                      ),
                      title: Text(
                        action.label,
                        style: action.destructive
                            ? TextStyle(color: danger)
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
      body: Builder(builder: viewBuilder),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: onEdit,
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Edit'),
      ),
    );
  }

  Widget _editMode(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Close',
          onPressed: () => UnsavedChangesScope.leaveEditing(
            context,
            isDirty: isDirty,
            onSave: onSave,
            onDiscard: onDiscard,
          ),
        ),
        title: Text(isNew ? 'New $noun' : 'Edit $noun'),
      ),
      body: Builder(builder: editBuilder),
      bottomNavigationBar: SaveBar(
        saveLabel: isNew ? 'Create $noun' : 'Save',
        isSaving: isSaving,
        onSave: onSave,
        onDiscard: onDiscard,
      ),
    );
  }
}
