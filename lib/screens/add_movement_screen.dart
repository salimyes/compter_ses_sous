import 'package:flutter/material.dart';
import '../models/movement.dart';

class AddMovementScreen extends StatefulWidget {
  final Movement? movement;

  AddMovementScreen({this.movement});

  @override
  _AddMovementScreenState createState() => _AddMovementScreenState();
}

class _AddMovementScreenState extends State<AddMovementScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String amountText; // Stocke le texte du montant
  late int selectedDay;
  late String selectedType; // "Entrée" ou "Dépense"
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    name = widget.movement?.name ?? '';
    amountText = widget.movement?.amount != null && widget.movement!.amount != 0
        ? widget.movement!.amount.toString()
        : ''; // Par défaut, champ vide
    selectedDay = widget.movement?.date.day ?? DateTime.now().day;
    selectedType = widget.movement?.amount != null && widget.movement!.amount < 0
        ? 'Dépense'
        : 'Entrée';

    _amountController.text = amountText;

    // Efface le texte dès que l'utilisateur clique dans le champ
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movement == null ? 'Ajouter un mouvement' : 'Modifier un mouvement')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nom du mouvement
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Nom du mouvement'),
                onChanged: (value) => name = value,
              ),

              // Montant du mouvement
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Montant'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  amountText = value;
                },
              ),

              SizedBox(height: 20),

              // Sélection du jour du mois
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Jour du paiement : $selectedDay'),
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

              SizedBox(height: 20),

              // Sélection du type de mouvement
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Type de mouvement :'),
                  DropdownButton<String>(
                    value: selectedType,
                    items: ['Entrée', 'Dépense']
                        .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedType = value;
                        });
                      }
                    },
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Bouton d'enregistrement
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    double amount = double.tryParse(amountText) ?? 0.0;
                    if (selectedType == 'Dépense' && amount > 0) {
                      amount = -amount; // Convertir en négatif si c'est une dépense
                    }

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
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
