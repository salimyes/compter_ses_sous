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

  double get totalAmount {
    return movements.fold(0, (sum, movement) => sum + movement.amount);
  }

  Movement? getNextMovement() {
    movements.sort((a, b) => a.date.compareTo(b.date));
    DateTime now = DateTime.now();

    for (Movement movement in movements) {
      if (movement.date.isAfter(now)) {
        return movement;
      }
    }
    return null;
  }

  void addMovement(Movement movement) {
    setState(() {
      movements.add(movement);
    });
  }

  void editMovement(Movement oldMovement, Movement newMovement) {
    setState(() {
      int index = movements.indexOf(oldMovement);
      if (index != -1) {
        movements[index] = newMovement;
      }
    });
  }

  void deleteMovement(Movement movement) {
    setState(() {
      movements.remove(movement);
    });
  }

  @override
  Widget build(BuildContext context) {
    String monthText = _getMonthName(selectedDate.month).toUpperCase();
    String yearText = selectedDate.year.toString();
    Movement? nextMovement = getNextMovement();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade300,
        toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/icons/app_logo.png', height: 30),
            const Text(
              'COMPTER SES SOUS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            '$monthText $yearText',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          CalendarWidget(
            movements: movements,
            onEdit: editMovement,
            onDelete: deleteMovement,
            selectedDate: selectedDate,
            onAdd: addMovement,
          ),
          const SizedBox(height: 10),

          if (nextMovement != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                _getNextMovementText(nextMovement),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

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
              'Ajouter un mouvement',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _getNextMovementText(Movement movement) {
    String type = movement.amount < 0 ? 'dépense' : 'entrée';
    String motType = movement.amount < 0 ? 'prélèvement' : 'versement';
    String formattedAmount = movement.amount.toStringAsFixed(2).replaceAll('.00', '');

    return 'Prochaine $type : \n"${movement.name}" $motType de :\n $formattedAmount€ le ${movement.date.day}/${movement.date.month}/${movement.date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return months[month - 1];
  }
}
