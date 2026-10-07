import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Calls [onShown] whenever the app comes back to [location]: switching to
/// its tab, or closing a screen pushed on top. For tabs whose data can change
/// elsewhere (lessons marked paid, notes written from a student's page).
class RefreshOnShow extends StatefulWidget {
  final String location;
  final VoidCallback onShown;
  final Widget child;

  const RefreshOnShow({
    super.key,
    required this.location,
    required this.onShown,
    required this.child,
  });

  @override
  State<RefreshOnShow> createState() => _RefreshOnShowState();
}

class _RefreshOnShowState extends State<RefreshOnShow> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter.of(context);
    _router.routerDelegate.addListener(_onNavigation);
  }

  @override
  void dispose() {
    _router.routerDelegate.removeListener(_onNavigation);
    super.dispose();
  }

  void _onNavigation() {
    final location = _router.routerDelegate.currentConfiguration.uri.path;
    if (location == widget.location && mounted) widget.onShown();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
