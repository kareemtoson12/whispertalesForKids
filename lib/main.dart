import 'package:flutter/material.dart';

import 'package:gp/features/questions/qs.dart';
import 'features/splash/splashView.dart';
import 'features/createStory/CreateStoryView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhisperTales',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF88C9FF), // Sky blue as primary color
          primary: const Color(0xFF88C9FF),
          secondary: const Color(0xFFFFB5D8), // Pastel pink
          tertiary: const Color(0xFFA8E6CF), // Mint green
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A4A4A),
          ),
          bodyLarge: TextStyle(fontSize: 18),
          labelLarge: TextStyle(fontSize: 20),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => CreateStoryView(),
        '/magical-quiz': (context) => const MagicalQuizScreen(),
      },
    );
  }
}
