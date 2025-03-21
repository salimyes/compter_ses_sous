import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(false);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'COMPTER SES SOUS',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: isDarkMode ? Colors.black : Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
              titleTextStyle: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
