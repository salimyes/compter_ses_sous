import 'package:flutter/material.dart';
import 'calendar_page.dart'; // Importe le fichier où se trouve le calendrier

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: CalendarPage(), // Affiche la page du calendrier comme page d'accueil
    );
  }
}
