import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/layout/empty_state.dart';
import 'package:flutter/material.dart';

/// Shows [child] with loading / error / empty states layered on top,
/// based on a [CubitState].
class StateTransitionWidget extends StatelessWidget {
  final CubitState state;
  final Widget child;
  final bool? isEmpty;

  /// Shown when the state is empty. Defaults to a generic [EmptyState].
  final Widget? empty;

  /// Offered on the error state when set.
  final VoidCallback? onRetry;

  /// Dims the content with a spinner while loading. Turn off for screens
  /// that reload often and quickly (calendar paging) to avoid flicker.
  final bool loadingOverlay;

  const StateTransitionWidget({
    super.key,
    required this.state,
    required this.child,
    this.isEmpty,
    this.empty,
    this.onRetry,
    this.loadingOverlay = true,
  });

  @override
  Widget build(BuildContext context) {
    final showEmpty =
        (isEmpty ?? state.isEmpty) && !state.isLoading && state.error == null;

    return Stack(
      children: [
        child,
        if (state.isLoading && loadingOverlay)
          Positioned.fill(
            child: ColoredBox(
              color: context.tokens.bg.withValues(alpha: 0.6),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        if (state.error != null)
          Positioned.fill(
            child: ColoredBox(
              color: context.tokens.bg,
              child: EmptyState(
                icon: Icons.error_outline_rounded,
                title: 'Something went wrong',
                message: state.error,
                actionLabel: onRetry != null ? 'Try again' : null,
                onAction: onRetry,
              ),
            ),
          ),
        if (showEmpty)
          Positioned.fill(
            child:
                empty ??
                const EmptyState(
                  icon: Icons.inbox_outlined,
                  title: 'Nothing here yet',
                  compact: true,
                ),
          ),
      ],
    );
  }
}
