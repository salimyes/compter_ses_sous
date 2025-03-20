import 'package:flutter/material.dart';
import '../models/movement.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/total_display.dart';
import 'add_movement_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movement> movements = [];
  DateTime selectedDate = DateTime.now();

  // Calcul du total des transactions
  double get totalAmount {
    return movements.fold(0, (sum, movement) => sum + movement.amount);
  }

  // Ajouter un mouvement
  void addMovement(Movement movement) {
    setState(() {
      movements.add(movement);
    });
  }

  // Modifier un mouvement
  void editMovement(Movement oldMovement, Movement newMovement) {
    setState(() {
      int index = movements.indexOf(oldMovement);
      if (index != -1) {
        movements[index] = newMovement;
      }
    });
  }

  // Supprimer un mouvement
  void deleteMovement(Movement movement) {
    setState(() {
      movements.remove(movement);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Exemple : affichage du mois en lettres
    String monthText = _getMonthName(selectedDate.month).toUpperCase();
    String yearText = selectedDate.year.toString();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset('assets/icons/app_logo.png', height: 30), // logo à gauche (assure-toi que le fichier existe)
                const SizedBox(width: 8),
                const Text('COMPTER SES SOUS', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Action pour les paramètres
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            '$monthText $yearText',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Le calendrier occupe environ 70% de l'écran
          CalendarWidget(
            movements: movements,
            onEdit: editMovement,
            onDelete: deleteMovement,
            selectedDate: selectedDate,
          ),
          const SizedBox(height: 10),
          TotalDisplay(total: totalAmount),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddMovementScreen(),
                ),
              );
              if (result != null) addMovement(result);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
            child: const Text(
              'AJOUTER UN MOUVEMENT',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return months[month - 1];
  }
}
