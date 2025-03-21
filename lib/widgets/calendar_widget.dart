import 'package:flutter/material.dart';
import '../models/movement.dart';
import '../screens/add_movement_screen.dart';
import '../main.dart'; // Import pour récupérer le ValueNotifier isDarkModeNotifier

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
    DateTime today = DateTime.now();

    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                height: screenHeight * 0.4,
                width: screenWidth * 0.90,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
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

                    double totalAmount = dayMovements.fold(0.0, (sum, m) => sum + m.amount);

                    bool isToday = date.day == today.day && date.month == today.month && date.year == today.year;

                    return GestureDetector(
                      onTap: () async {
                        if (dayMovements.isNotEmpty) {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Mouvements du ${date.day}/${date.month}/${date.year}'),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ...dayMovements.map((movement) => ListTile(
                                      title: Text(movement.name),
                                      subtitle: Text(
                                        _formatAmount(movement.amount),
                                        style: TextStyle(
                                          color: movement.amount >= 0 ? Colors.green : Colors.red,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () async {
                                              final newMovement = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => AddMovementScreen(movement: movement),
                                                ),
                                              );
                                              if (newMovement != null) onEdit(movement, newMovement);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              onDelete(movement);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    )),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final newMovement = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddMovementScreen(
                                              movement: Movement(
                                                name: '',
                                                amount: 0.0,
                                                date: date,
                                              ),
                                            ),
                                          ),
                                        );
                                        if (newMovement != null) onAdd(newMovement);
                                      },
                                      child: const Text('Ajouter Nouveau'),
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
                                movement: Movement(
                                  name: '',
                                  amount: 0.0,
                                  date: date,
                                ),
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
                                color: isDarkMode ? Colors.black : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: isToday ? Border.all(color: Colors.green, width: 2) : null,
                              ),
                              child: totalAmount != 0 ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      _formatAmount(totalAmount),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: totalAmount >= 0 ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ) : null,
                            ),
                          ),
                          Positioned(
                            bottom: -20,
                            left: 0,
                            right: 0,
                            child: Text(
                              '${index + 1}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isDarkMode ? Colors.white : Colors.black,
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
      },
    );
  }

  String _formatAmount(double amount) {
    if (amount == amount.toInt()) {
      return '${amount.toInt()}€';
    }
    return '${amount.toStringAsFixed(2)}€';
  }
}
