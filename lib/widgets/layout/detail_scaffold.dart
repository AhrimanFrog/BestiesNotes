import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/buttons/save_bar.dart';
import 'package:besties_notes/widgets/layout/empty_state.dart';
import 'package:besties_notes/widgets/layout/unsaved_changes_scope.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The entity-specific texts of a [DetailScaffold].
class DetailTexts {
  /// "New lesson".
  final String newTitle;

  /// "Edit lesson".
  final String editTitle;

  /// Save-button label when creating: "Create lesson".
  final String createLabel;

  /// "This lesson may have been deleted."
  final String notFound;

  const DetailTexts({
    required this.newTitle,
    required this.editTitle,
    required this.createLabel,
    required this.notFound,
  });
}

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
  /// Per-entity texts. Whole phrases rather than a noun to splice in:
  /// languages inflect them differently ("Новий урок" / "Нова група").
  final DetailTexts texts;

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
    required this.texts,
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
                title: context.l10n.stateNotFoundTitle,
                message: texts.notFound,
                actionLabel: context.l10n.commonBack,
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
              tooltip: context.l10n.commonMore,
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
        label: Text(context.l10n.commonEdit),
      ),
    );
  }

  Widget _editMode(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: context.l10n.commonClose,
          onPressed: () => UnsavedChangesScope.leaveEditing(
            context,
            isDirty: isDirty,
            onSave: onSave,
            onDiscard: onDiscard,
          ),
        ),
        title: Text(isNew ? texts.newTitle : texts.editTitle),
      ),
      body: Builder(builder: editBuilder),
      bottomNavigationBar: SaveBar(
        saveLabel: isNew ? texts.createLabel : context.l10n.commonSave,
        isSaving: isSaving,
        onSave: onSave,
        onDiscard: onDiscard,
      ),
    );
  }
}
