class Recipe {
  late final String name;
  final String region;
  final List<String> ingredients;
  final List<String> steps;

  Recipe(
      {required this.name,
      required this.region,
      required this.ingredients,
      required this.steps});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'] as String? ?? 'Desconocido', // Valor por defecto
      region: json['region'] as String? ?? 'Desconocida', // Valor por defecto
      ingredients:
          List<String>.from(json['ingredients'] ?? []), // Manejo de null
      steps: List<String>.from(json['steps'] ?? []), // Manejo de null
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'name': name,
      'region': region,
      'ingredients': ingredients,
      'steps': steps,
    };
  }
}