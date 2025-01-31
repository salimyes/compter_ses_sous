import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late int _daysInMonth;
  late int _currentMonth;
  late int _currentYear;
  Map<int, List<Map<String, dynamic>>> _movements = {}; // Stocke les mouvements par jour

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = now.month;
    _currentYear = now.year;
    _daysInMonth = _getDaysInMonth(_currentYear, _currentMonth);
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  void _addMovement() {
    int selectedDay = 1;
    String movementName = "";
    double movementAmount = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ajouter un mouvement"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sélection du jour
              DropdownButton<int>(
                value: selectedDay,
                items: List.generate(
                  _daysInMonth,
                      (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text("Jour ${index + 1}"),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedDay = value!;
                  });
                },
              ),
              // Nom du mouvement
              TextField(
                decoration: InputDecoration(labelText: "Nom du mouvement"),
                onChanged: (value) {
                  movementName = value;
                },
              ),
              // Montant
              TextField(
                decoration: InputDecoration(labelText: "Montant"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  movementAmount = double.tryParse(value) ?? 0.0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                if (movementName.isNotEmpty) {
                  setState(() {
                    _movements.putIfAbsent(selectedDay, () => []);
                    _movements[selectedDay]!.add({
                      "nom": movementName,
                      "montant": movementAmount,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendrier')),
      body: Column(
        children: [
          // 📆 Le calendrier
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _daysInMonth,
              itemBuilder: (context, index) {
                final day = index + 1;
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$day', style: TextStyle(fontWeight: FontWeight.bold)),
                      if (_movements.containsKey(day)) ..._movements[day]!.map(
                            (movement) => Text("${movement['nom']} - ${movement['montant']}€",
                            style: TextStyle(fontSize: 10)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // 📌 Le bouton "Ajouter un mouvement"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _addMovement,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // Fond gris
                foregroundColor: Colors.white, // Texte blanc
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
              child: Text("Ajouter un mouvement", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
