import 'package:besties_notes/providers/data_provider.dart';
import 'package:besties_notes/providers/db_client.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:besties_notes/providers/recurring_provider.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final db = DbClient();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DataProvider>(create: (_) => db),
        RepositoryProvider<PaymentProvider>(create: (_) => db),
        RepositoryProvider<RecurringProvider>(create: (_) => db),
      ],
      child: MaterialApp.router(
        title: 'Besties Notes',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.accentPink,
          ).copyWith(primary: AppColors.accentPink, onPrimary: Colors.white),
        ),
        routerConfig: router,
      ),
    ),
  );
}
