import 'package:flutter/material.dart';
import '../models/movement.dart';

class AddMovementScreen extends StatefulWidget {
  final Movement? movement;

  const AddMovementScreen({super.key, this.movement});

  @override
  _AddMovementScreenState createState() => _AddMovementScreenState();
}

class _AddMovementScreenState extends State<AddMovementScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String amountText;
  late int selectedDay;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    name = widget.movement?.name ?? '';
    amountText = (widget.movement?.amount != null && widget.movement!.amount != 0)
        ? widget.movement!.amount.abs().toString()
        : '';
    selectedDay = widget.movement?.date.day ?? DateTime.now().day;

    _amountController.text = amountText;

    _amountController.addListener(() {
      if (_amountController.text == '0.0') {
        _amountController.clear();
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  /// Fonction pour convertir l'entrée de l'utilisateur en nombre valide
  double? _parseAmount(String value) {
    value = value.replaceAll(',', '.'); // Remplace les virgules par des points

    final doubleValue = double.tryParse(value);

    if (doubleValue != null && doubleValue == doubleValue.floorToDouble()) {
      // Si c'est un nombre entier, retourne l'entier
      return doubleValue.toInt().toDouble();
    }
    return doubleValue; // Retourne le nombre double s'il n'est pas entier
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movement == null ? 'Ajouter un mouvement' : 'Modifier un mouvement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Nom du mouvement
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(
                  labelText: 'Nom du mouvement',
                  border: OutlineInputBorder(),
                ),
                textAlign: TextAlign.center,
                onChanged: (value) => name = value,
              ),
              const SizedBox(height: 20),

              // Montant du mouvement
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Montant',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  amountText = value;
                },
              ),
              const SizedBox(height: 20),

              // Sélection du jour (seul le jour est sélectionné)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Jour du paiement : '),
                  DropdownButton<int>(
                    value: selectedDay,
                    items: List.generate(31, (index) => index + 1)
                        .map((day) => DropdownMenuItem(
                      value: day,
                      child: Text(day.toString()),
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

              // Boutons pour ajouter une dépense ou une entrée
              Center(
                child: Column(
                  children: [
                    // Bouton "Ajouter cette dépense"
                    SizedBox(
                      width: buttonWidth,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            double? amount = _parseAmount(amountText) ?? 0.0;
                            if (amount > 0) amount = -amount;
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

                    // Bouton "Ajouter cette entrée"
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
  }
}
