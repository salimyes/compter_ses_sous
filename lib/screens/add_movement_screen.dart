import 'package:flutter/material.dart';
import '../models/movement.dart';
import '../main.dart';

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

  double? _parseAmount(String value) {
    value = value.replaceAll(',', '.'); // 15,99 devient 15.99
    final doubleValue = double.tryParse(value);

    if (doubleValue != null && doubleValue == doubleValue.floorToDouble()) {
      return doubleValue.toInt().toDouble();
    }
    return doubleValue;
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;

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
