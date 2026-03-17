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
          const ColoredBox(
            color: Colors.black12,
            child: Center(child: CircularProgressIndicator()),
          ),
        if (state.error != null)
          ColoredBox(
            color: Colors.black12,
            child: Center(child: Text(state.error!)),
          ),
      ],
    );
  }
}
