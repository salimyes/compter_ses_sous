import 'package:flutter/material.dart';
import '../models/movement.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/total_display.dart';
import 'add_movement_screen.dart';
import '../main.dart'; // pour accéder au isDarkModeNotifier

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movement> movements = []; // liste qui va contenir tous les mouvements
  DateTime selectedDate = DateTime.now(); // date sélectionnée (mois actuel affiché)

  double get totalAmount {
    // calcule la somme totale de tous les mouvements
    return movements.fold(0, (sum, movement) => sum + movement.amount);
  }

  Movement? getNextMovement() {
    // récupère le mouvement le plus proche qui est à venir
    movements.sort((a, b) => a.date.compareTo(b.date));
    DateTime now = DateTime.now();

    for (Movement movement in movements) {
      if (movement.date.isAfter(now)) { // mouvement qui n'est pas encore arrivé
        return movement;
      }
    }
    return null; // aucun mouvement à venir trouvé
  }

  void addMovement(Movement movement) {
    // ajoute un nouveau mouvement à la liste
    setState(() {
      movements.add(movement);
    });
  }

  void editMovement(Movement oldMovement, Movement newMovement) {
    // modifie un mouvement existant
    setState(() {
      int index = movements.indexOf(oldMovement);
      if (index != -1) {
        movements[index] = newMovement;
      }
    });
  }

  void deleteMovement(Movement movement) {
    // supprime un mouvement de la liste
    setState(() {
      movements.remove(movement);
    });
  }

  void toggleDarkMode() {
    // change le mode sombre / clair
    isDarkModeNotifier.value = !isDarkModeNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    String monthText = _getMonthName(selectedDate.month).toUpperCase(); // obtient le nom du mois actuel en lettres
    String yearText = selectedDate.year.toString(); // obtient l'année actuelle
    Movement? nextMovement = getNextMovement(); // cherche le prochain mouvement prévu
    double screenHeight = MediaQuery.of(context).size.height; // hauteur de l'écran

    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
            toolbarHeight: 60,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/icons/app_logo.png', height: 30), // icône de l'application
                const Text(
                  'COMPTER SES SOUS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: toggleDarkMode,
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: CalendarWidget(
                  movements: movements,
                  onEdit: editMovement,
                  onDelete: deleteMovement,
                  selectedDate: selectedDate,
                  onAdd: addMovement,
                ),
              ),
              SizedBox(height: screenHeight * 0.05), // espace avant le texte de la prochaine dépense

              if (nextMovement != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(
                    _getNextMovementText(nextMovement),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),

              TotalDisplay(total: totalAmount), // affiche le montant total des mouvements
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  // quand on appuie sur ce bouton, on ouvre la page pour ajouter un mouvement
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddMovementScreen(),
                    ),
                  );
                  if (result != null) addMovement(result); // si un mouvement est ajouté, on le rajoute à la liste
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
              SizedBox(height: screenHeight * 0.05), // espace en bas de l'écran
            ],
          ),
        );
      },
    );
  }

  String _getNextMovementText(Movement movement) {
    // génère un texte qui affiche la prochaine dépense/entrée prévue
    String type = movement.amount < 0 ? 'dépense' : 'entrée';
    String motType = movement.amount < 0 ? 'prélèvement' : 'versement';
    String formattedAmount = movement.amount.toStringAsFixed(2).replaceAll('.00', '');

    return 'Prochaine $type : \n"${movement.name}" $motType de :\n $formattedAmount€ le ${movement.date.day}/${movement.date.month}/${movement.date.year}';
  }

  String _getMonthName(int month) {
    // convertit un numéro de mois en son nom en français
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return months[month - 1];
  }
}
