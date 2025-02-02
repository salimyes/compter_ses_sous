import 'package:flutter/material.dart';

class TotalDisplay extends StatelessWidget {
  final double total;

  TotalDisplay({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      color: total >= 0 ? Colors.green.shade300 : Colors.red.shade300,
      child: Text(
        'Total: ${total.toStringAsFixed(2)}€',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
