import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:flutter/material.dart';

class StateTransitionWidget extends StatelessWidget {
  final CubitState state;
  final Widget child;

  const StateTransitionWidget({
    super.key,
    required this.state,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (state.isLoading)
          const Positioned.fill(
            child: ColoredBox(
              color: Colors.black12,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        if (state.error != null)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black12,
              child: Center(child: Text(state.error!)),
            ),
          ),
        if (state.isEmpty && !state.isLoading && state.error == null)
          Positioned.fill(
            child: Center(
              child: const Text(
                'No entries yet',
                style: TextStyle(color: AppColors.secondaryText, fontSize: 16),
              ),
            ),
          ),
      ],
    );
  }
}
