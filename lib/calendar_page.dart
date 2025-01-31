import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendrier'),
        centerTitle: true,
      ),
      body: CalendarWidget(),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late int _daysInMonth;
  late int _currentMonth;
  late int _currentYear;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = now.month;
    _currentYear = now.year;
    _daysInMonth = _getDaysInMonth(_currentYear, _currentMonth);
  }

  // Détermine le nombre de jours dans le mois
  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // 7 colonnes pour une semaine
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: _daysInMonth,
      itemBuilder: (context, index) {
        final day = index + 1;
        return GestureDetector(
          onTap: () {
            // Action au clic sur une case
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Jour $day'),
                content: Text('Ajouter des données ici.'),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.add_photo_alternate_outlined, size: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
