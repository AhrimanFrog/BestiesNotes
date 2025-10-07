import 'package:besties_notes/widgets/white_box.dart';
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
          body: const TabBarView(children: [WhiteBox(), WhiteBox()]),
        ),
      ),
    );
  }
}
