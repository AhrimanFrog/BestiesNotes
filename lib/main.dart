import 'package:besties_notes/providers/db_client.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    RepositoryProvider(
      create: (_) => ScheduleRepo(dataProvider: DbClient()),
      child: MaterialApp.router(
        title: 'Besties Notes',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accentPink),
        ),
        routerConfig: router,
      ),
    ),
  );
}
