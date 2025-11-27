import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TagQuestionApp());
}

class TagQuestionApp extends StatelessWidget {
  const TagQuestionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belajar Tag Question',
      debugShowCheckedModeBanner: false,

      // Tema utama
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),

      // Tema dark mode (opsional, saya gabungkan dari versi remote)
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      themeMode: ThemeMode.system,

      initialRoute: '/',
      onGenerateRoute: appRouteGenerator,
    );
  }
}
