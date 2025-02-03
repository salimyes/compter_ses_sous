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
  late double amount;
  late int selectedDay;
  String transactionType = 'Entrée'; // Valeurs possibles : Entrée, Sortie

  @override
  void initState() {
    super.initState();
    name = widget.movement?.name ?? '';
    amount = widget.movement?.amount.abs() ?? 0.0; // Toujours positif en entrée
    selectedDay = widget.movement?.date.day ?? DateTime.now().day;
    transactionType = (widget.movement?.amount ?? 0) >= 0 ? 'Entrée' : 'Sortie';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Nom du mouvement'),
                onChanged: (value) => name = value,
              ),
              TextFormField(
                initialValue: amount.toString(),
                decoration: InputDecoration(labelText: 'Montant'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  double? enteredAmount = double.tryParse(value);
                  if (enteredAmount != null && enteredAmount >= 0) {
                    amount = enteredAmount;
                  }
                },
              ),
              SizedBox(height: 20),
              Text("Sélectionner le jour du paiement :"),
              DropdownButton<int>(
                value: selectedDay,
                items: List.generate(31, (index) => index + 1)
                    .map((day) => DropdownMenuItem(value: day, child: Text("Jour $day")))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDay = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              Text("Type de transaction :"),
              DropdownButton<String>(
                value: transactionType,
                items: ['Entrée', 'Sortie']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    transactionType = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    double finalAmount = transactionType == 'Sortie' ? -amount : amount;
                    Navigator.pop(
                      context,
                      Movement(name: name, amount: finalAmount, date: DateTime(DateTime.now().year, DateTime.now().month, selectedDay)),
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
