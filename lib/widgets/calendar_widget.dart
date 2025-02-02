import 'package:flutter/material.dart';
import '../models/movement.dart';
import '../screens/add_movement_screen.dart';

class CalendarWidget extends StatelessWidget {
  final List<Movement> movements;
  final Function(Movement, Movement) onEdit;
  final Function(Movement) onDelete;
  final DateTime selectedDate;

  CalendarWidget({required this.movements, required this.onEdit, required this.onDelete, required this.selectedDate});

  int get daysInMonth {
    return DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.2,
      ),
      itemCount: daysInMonth,
      itemBuilder: (context, index) {
        DateTime date = DateTime(selectedDate.year, selectedDate.month, index + 1);
        Movement? movement = movements.firstWhere(
              (m) => m.date.year == date.year && m.date.month == date.month && m.date.day == date.day,
          orElse: () => Movement(name: '', amount: 0, date: date),
        );

        return GestureDetector(
          onTap: () async {
            if (movement.name.isNotEmpty) {
              final result = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Modifier ou supprimer"),
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
                      child: Text("Modifier"),
                    ),
                    TextButton(
                      onPressed: () {
                        onDelete(movement);
                        Navigator.pop(context);
                      },
                      child: Text("Supprimer"),
                    ),
                  ],
                ),
              );
            }
          },
          child: Card(
            color: movement.amount != 0 ? Colors.blue.shade100 : Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                if (movement.name.isNotEmpty) ...[
                  Text(movement.name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  Text('${movement.amount}€', style: TextStyle(fontSize: 12, color: movement.amount >= 0 ? Colors.green : Colors.red)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
