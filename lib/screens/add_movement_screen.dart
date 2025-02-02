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
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    name = widget.movement?.name ?? '';
    amount = widget.movement?.amount ?? 0.0;
    selectedDate = widget.movement?.date ?? DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Nom du mouvement'),
                onChanged: (value) => name = value,
              ),
              TextFormField(
                initialValue: amount.toString(),
                decoration: InputDecoration(labelText: 'Montant'),
                keyboardType: TextInputType.number,
                onChanged: (value) => amount = double.tryParse(value) ?? 0.0,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Date : ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Sélectionner une date'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, Movement(name: name, amount: amount, date: selectedDate));
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
