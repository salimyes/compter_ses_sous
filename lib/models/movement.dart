class Movement {
  String name; // nom du mouvement, par exemple "Salaire" ou "Loyer"
  double amount; // montant du mouvement, positif pour une entrée, négatif pour une dépense
  DateTime date; // date à laquelle le mouvement est associé

  Movement({required this.name, required this.amount, required this.date});
}
