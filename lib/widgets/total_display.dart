import 'package:flutter/material.dart';

class TotalDisplay extends StatelessWidget {
  final double total; // valeur totale des mouvements

  const TotalDisplay({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // marges internes du conteneur
      decoration: BoxDecoration(
        color: total >= 0 ? Colors.green : Colors.red, // vert si c'est positif, rouge si c'est négatif
        borderRadius: BorderRadius.circular(16), // bords arrondis
      ),
      child: Text(
        'TOTAL : ${total.toStringAsFixed(2)}€', // affiche le total avec deux décimales
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white, // texte en blanc pour contraster avec le fond
        ),
      ),
    );
  }
}
