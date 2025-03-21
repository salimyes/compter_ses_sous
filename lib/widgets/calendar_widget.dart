import 'package:flutter/material.dart';
import '../models/movement.dart';
import '../screens/add_movement_screen.dart';

class CalendarWidget extends StatelessWidget {
  final List<Movement> movements;
  final Function(Movement, Movement) onEdit;
  final Function(Movement) onDelete;
  final Function(Movement) onAdd;
  final DateTime selectedDate;

  CalendarWidget({
    required this.movements,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
    required this.selectedDate,
  });

  int get daysInMonth {
    return DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            height: screenHeight * 0.4,
            width: screenWidth * 0.90,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 24,
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
                    } else {
                      final newMovement = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddMovementScreen(movement: movement),
                        ),
                      );
                      if (newMovement != null) onAdd(newMovement);
                    }
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: movement.name.isNotEmpty
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/${movement.name.toLowerCase()}.png',
                                height: 20,
                              ),
                              const SizedBox(height: 2),
                              FittedBox( // Réduit automatiquement la taille du texte si nécessaire
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _formatAmount(movement.amount),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: movement.amount >= 0 ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: -20,
                        left: 0,
                        right: 0,
                        child: Text(
                          '${index + 1}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount == amount.toInt()) {
      return '${amount.toInt()}€';
    }
    return '${amount.toStringAsFixed(2)}€';
  }
}
