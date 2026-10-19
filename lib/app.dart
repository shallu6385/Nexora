import 'package:flutter/material.dart';

import 'features/presentation/login.dart';

class Nexora extends StatelessWidget {
  const Nexora({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexora',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',

        scaffoldBackgroundColor: const Color(0xFFF7F9FC),

        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B3473)),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B3473),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0B3473),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),

      // App opens with Login page
      home: const LoginScreen(),
    );
  }
}
