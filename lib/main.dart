import 'package:flutter/material.dart';

import 'pages/schedule_page.dart';
import 'pages/students_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Besties Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 234, 116, 155),
        ),
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: Container(
            color: Theme.of(context).colorScheme.surface,
            child: const TabBar(
              padding: EdgeInsets.only(bottom: 20),
              dividerHeight: 0,
              indicator: BoxDecoration(),
              tabs: [
                Tab(icon: Icon(Icons.calendar_month, size: 50)),
                Tab(icon: Icon(Icons.school, size: 50)),
              ],
            ),
          ),
          body: const TabBarView(children: [SchedulePage(), StudentsPage()]),
        ),
      ),
    );
  }
}
