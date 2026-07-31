import 'package:besties_notes/providers/data_provider.dart';
import 'package:besties_notes/providers/db_client.dart';
import 'package:besties_notes/providers/payment_provider.dart';
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
      ],
      child: MaterialApp.router(
        title: 'Besties Notes',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 228, 193, 199),
            primary: const Color(0xFFF291A3),
            onPrimary: Colors.white,
            secondary: Color(0xFFE8F0FA),
            onSecondary: const Color(0xFF85A8D0),
            tertiary: Color(0xFFE6F4EA),
            onTertiary: Color(0xFF66BB6A),
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.mainText,
            ),
            titleMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.mainText,
            ),
            bodyMedium: TextStyle(fontSize: 14, color: AppColors.mainText),
            bodyLarge: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.mainText,
            ),
            bodySmall: TextStyle(fontSize: 14, color: AppColors.secondaryText),
            labelMedium: TextStyle(
              fontSize: 12,
              color: AppColors.secondaryText,
            ),
            labelSmall: TextStyle(fontSize: 9, color: AppColors.secondaryText),
          ),
        ),
        routerConfig: router,
      ),
    ),
  );
}
