import 'package:besties_notes/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show StatefulNavigationShell;

class MainBottomBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainBottomBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: AppColors.accentGrey,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Scholars'),
        ],
      ),
    );
  }
}
