import 'package:flutter/material.dart';
import '../models/movement.dart';
import '../main.dart'; // import pour récupérer le ValueNotifier isDarkModeNotifier

class AddMovementScreen extends StatefulWidget {
  final Movement? movement; // mouvement passé en argument pour modification éventuelle

  const AddMovementScreen({super.key, this.movement});

  @override
  _AddMovementScreenState createState() => _AddMovementScreenState();
}

class _AddMovementScreenState extends State<AddMovementScreen> {
  final _formKey = GlobalKey<FormState>(); // clé du formulaire pour validation
  late String name; // nom du mouvement
  late String amountText; // montant sous forme de texte
  late int selectedDay; // jour sélectionné pour le mouvement
  final TextEditingController _amountController = TextEditingController(); // contrôleur pour le champ montant

  @override
  void initState() {
    super.initState();
    name = widget.movement?.name ?? ''; // récupère le nom du mouvement ou une chaîne vide par défaut
    amountText = (widget.movement?.amount != null && widget.movement!.amount != 0)
        ? widget.movement!.amount.abs().toString()
        : ''; // affiche le montant si fourni, sinon laisse vide
    selectedDay = widget.movement?.date.day ?? DateTime.now().day; // jour par défaut : aujourd'hui

    _amountController.text = amountText; // initialisation du champ de saisie montant

    _amountController.addListener(() {
      if (_amountController.text == '0.0') {
        _amountController.clear(); // retire le zéro si l'utilisateur ne tape que ça
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose(); // libère les ressources
    super.dispose();
  }

  double? _parseAmount(String value) {
    value = value.replaceAll(',', '.'); // remplace les virgules par des points pour éviter les erreurs
    final doubleValue = double.tryParse(value);

    if (doubleValue != null && doubleValue == doubleValue.floorToDouble()) {
      return doubleValue.toInt().toDouble(); // si c'est un entier, le retourne en tant que double entier
    }
    return doubleValue; // retourne la valeur en double s'il n'est pas entier
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.8; // largeur des boutons

    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
            iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
            title: Text(
              widget.movement == null ? 'Ajouter un mouvement' : 'Modifier un mouvement',
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  TextFormField(
                    initialValue: name,
                    decoration: InputDecoration(
                      labelText: 'Nom du mouvement',
                      labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
                    ),
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    textAlign: TextAlign.center,
                    onChanged: (value) => name = value,
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Montant',
                      labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
                    ),
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      amountText = value;
                    },
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Jour du paiement : ',
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      DropdownButton<int>(
                        dropdownColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
                        value: selectedDay,
                        items: List.generate(31, (index) => index + 1)
                            .map((day) => DropdownMenuItem(
                          value: day,
                          child: Text(
                            day.toString(),
                            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                          ),
                        ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedDay = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: buttonWidth,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                double? amount = _parseAmount(amountText) ?? 0.0;
                                if (amount > 0) amount = -amount; // si c'est une dépense, montant négatif
                                Navigator.pop(
                                  context,
                                  Movement(
                                    name: name,
                                    amount: amount,
                                    date: DateTime(DateTime.now().year, DateTime.now().month, selectedDay),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'AJOUTER CETTE DÉPENSE',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: buttonWidth,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                double? amount = _parseAmount(amountText) ?? 0.0;
                                Navigator.pop(
                                  context,
                                  Movement(
                                    name: name,
                                    amount: amount,
                                    date: DateTime(DateTime.now().year, DateTime.now().month, selectedDay),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'AJOUTER CETTE ENTRÉE',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
