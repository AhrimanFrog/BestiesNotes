import 'package:besties_notes/views/schedule_view/schedule_view.dart';
import 'package:besties_notes/views/students_view/students_view.dart';
import 'package:besties_notes/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Besties Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accentPink),
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => {},
            ),
            actions: [IconButton(icon: Icon(Icons.add), onPressed: () => {})],
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            child: const TabBar(
              padding: EdgeInsets.only(bottom: 20),
              dividerHeight: 0,
              indicator: BoxDecoration(),
              labelColor: AppColors.accentPink,
              unselectedLabelColor: AppColors.softPink,
              tabs: [
                Tab(icon: Icon(Icons.calendar_month, size: 50)),
                Tab(icon: Icon(Icons.school, size: 50)),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              SchedulePage(),
              StudentsPage(students: []),
            ],
          ),
        ),
      ),
    );
  }
}
