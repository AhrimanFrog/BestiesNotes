import 'package:besties_notes/providers/data_provider.dart';
import 'package:besties_notes/providers/db_client.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
            seedColor: const Color(0xFF2B2530),
            primary: const Color(0xFFF4749A),
            onPrimary: Colors.white,
            secondary: Color(0xFFE8F0FA),
            onSecondary: const Color(0xFF85A8D0),
            tertiary: Color(0xFFE6F4EA),
            onTertiary: Color(0xFF66BB6A),
          ),
          textTheme: TextTheme(
            titleLarge: GoogleFonts.caprasimo(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
            titleMedium: GoogleFonts.caprasimo(
              fontSize: 17,
              color: AppColors.text,
            ),
            titleSmall: GoogleFonts.caprasimo(
              fontSize: 13,
              color: AppColors.text,
            ),
            bodyMedium: TextStyle(fontSize: 14, color: AppColors.text),
            bodyLarge: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
            bodySmall: TextStyle(fontSize: 14, color: AppColors.muted),
            labelMedium: TextStyle(fontSize: 12, color: AppColors.muted),
            labelSmall: TextStyle(fontSize: 9, color: AppColors.muted),
          ),
        ),
        routerConfig: router,
      ),
    ),
  );
}
