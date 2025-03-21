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

  double _calculateTotalAmountForDay(List<Movement> dayMovements) {
    return dayMovements.fold(0.0, (sum, movement) => sum + movement.amount);
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
                List<Movement> dayMovements = movements.where((m) => m.date.day == date.day).toList();
                double totalAmountForDay = _calculateTotalAmountForDay(dayMovements);

                return GestureDetector(
                  onTap: () async {
                    if (dayMovements.isNotEmpty) {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Mouvements du ${index + 1}"),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                ...dayMovements.map((movement) => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${movement.name} : ${movement.amount}€",
                                        style: TextStyle(
                                          color: movement.amount >= 0 ? Colors.green : Colors.red,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
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
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        onDelete(movement);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                )).toList(),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () async {
                                    final newMovement = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddMovementScreen(
                                          movement: Movement(name: '', amount: 0, date: date),
                                        ),
                                      ),
                                    );
                                    if (newMovement != null) onAdd(newMovement);
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Ajouter Nouveau",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      final newMovement = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddMovementScreen(
                            movement: Movement(name: '', amount: 0, date: date),
                          ),
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
                          child: dayMovements.isNotEmpty
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${totalAmountForDay.toStringAsFixed(2).replaceAll(".00", "")}€',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: totalAmountForDay >= 0 ? Colors.green : Colors.red,
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
}
