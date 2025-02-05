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

  // Calcul du total des transactions du mois
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
    return Scaffold(
      appBar: AppBar(title: const Text('Gestion des mouvements')),
      body: Column(
        children: [
          Expanded(
            child: CalendarWidget(
              movements: movements,
              onEdit: editMovement,
              onDelete: deleteMovement,
              selectedDate: selectedDate,
            ),
          ),
          TotalDisplay(total: totalAmount),
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
            child: const Text('Ajouter un mouvement'),
          ),
        ],
      ),
    );
  }
}
