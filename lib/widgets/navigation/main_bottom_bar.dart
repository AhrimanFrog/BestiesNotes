import 'package:besties_notes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show StatefulNavigationShell;

class MainBottomBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainBottomBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        // Re-tapping the active tab returns to its root.
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month_rounded),
            label: context.l10n.navSchedule,
          ),
          NavigationDestination(
            icon: const Icon(Icons.school_outlined),
            selectedIcon: const Icon(Icons.school_rounded),
            label: context.l10n.navStudents,
          ),
          NavigationDestination(
            icon: const Icon(Icons.insights_outlined),
            selectedIcon: const Icon(Icons.insights_rounded),
            label: context.l10n.navReports,
          ),
        ],
      ),
    );
  }
}
