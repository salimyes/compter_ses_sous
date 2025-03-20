import 'package:flutter/material.dart';
import '../models/movement.dart';
import '../screens/add_movement_screen.dart';

class CalendarWidget extends StatelessWidget {
  final List<Movement> movements;
  final Function(Movement, Movement) onEdit;
  final Function(Movement) onDelete;
  final DateTime selectedDate;

  CalendarWidget({
    required this.movements,
    required this.onEdit,
    required this.onDelete,
    required this.selectedDate,
  });

  int get daysInMonth {
    return DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        height: screenHeight * 0.38, // % de la hauteur de l'écran
        width: screenWidth * 0.90,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade300, // Couleur de fond gris clair
          borderRadius: BorderRadius.circular(16),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    if (movement.name.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Image.asset(
                        'assets/icons/${movement.name.toLowerCase()}.png', // Icône selon le type de mouvement
                        height: 24,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${movement.amount}€',
                        style: TextStyle(
                          fontSize: 12,
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
    );
  }
}
