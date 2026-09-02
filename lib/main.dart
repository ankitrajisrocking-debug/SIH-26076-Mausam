import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const MausamApp());
}

class MausamApp extends StatelessWidget {
  const MausamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mausam',
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF061C2D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0B6DB6),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}
