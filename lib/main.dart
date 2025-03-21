import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

// une variable globale qui va notifier les widgets quand le mode sombre est activé ou désactivé
final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(false);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier, // écoute les changements de isDarkModeNotifier
      builder: (context, isDarkMode, child) { // reconstruit l'interface si isDarkMode change
        return MaterialApp(
          debugShowCheckedModeBanner: false, // enlève le label debug en haut à droite
          title: 'COMPTER SES SOUS', // nom de l'appli
          theme: ThemeData(
            primarySwatch: Colors.blue, // thème principal en bleu
            scaffoldBackgroundColor: isDarkMode ? Colors.black : Colors.white, // couleur de fond selon le mode
            appBarTheme: AppBarTheme(
              backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white, // couleur de l'appbar selon le mode
              elevation: 0, // enlève l'ombre de l'appbar
              iconTheme: IconThemeData(
                  color: isDarkMode ? Colors.white : Colors.black), // couleur des icônes selon le mode
              titleTextStyle: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black, // couleur du titre selon le mode
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          home: const HomeScreen(), // l'écran principal de l'appli
        );
      },
    );
  }
}
