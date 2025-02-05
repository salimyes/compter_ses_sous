import 'package:flutter/material.dart';
import '../models/movement.dart';
import '../screens/add_movement_screen.dart';

class CalendarWidget extends StatelessWidget {
  final List<Movement> movements;
  final Function(Movement, Movement) onEdit;
  final Function(Movement) onDelete;
  final DateTime selectedDate;

  const CalendarWidget({super.key, required this.movements, required this.onEdit, required this.onDelete, required this.selectedDate});

  int get daysInMonth {
    return DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height; // Hauteur écran
    double screenWidth = MediaQuery.of(context).size.width; // Largeur écran

    return Container(
      height: screenHeight * 0.7, // Fixer la hauteur à 70% de l'écran
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 0.6, // Diminuer pour allonger les cases en hauteur
              ),
              itemCount: daysInMonth,
              itemBuilder: (context, index) {
                DateTime date = DateTime(selectedDate.year, selectedDate.month, index + 1);
                Movement? movement = movements.firstWhere(
                      (m) => m.date.day == date.day,
                  orElse: () => Movement(name: '', amount: 0, date: date),
                );

                return GestureDetector(
                  onTap: () async {
                    if (movement.name.isNotEmpty) {
                      final result = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Modifier ou supprimer"),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final newMovement = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddMovementScreen(movement: movement),
                                  ),
                                );
                                if (newMovement != null) onEdit(movement, newMovement);
                                Navigator.pop(context);
                              },
                              child: const Text("Modifier"),
                            ),
                            TextButton(
                              onPressed: () {
                                onDelete(movement);
                                Navigator.pop(context);
                              },
                              child: const Text("Supprimer"),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Card(
                    color: movement.amount != 0 ? Colors.blue.shade50 : Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        if (movement.name.isNotEmpty) ...[
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              movement.name,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            '${movement.amount}€',
                            style: TextStyle(
                              fontSize: 14,
                              color: movement.amount >= 0 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
