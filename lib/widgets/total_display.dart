import 'package:flutter/material.dart';

class TotalDisplay extends StatelessWidget {
  final double total;

  const TotalDisplay({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: total >= 0 ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'TOTAL : ${total.toStringAsFixed(2)}€',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
