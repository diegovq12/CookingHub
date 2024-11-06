class Recipe {
  final String name;
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
      name: json['nombre'] as String? ?? 'Desconocido', // Valor por defecto
      region: json['region'] as String? ?? 'Desconocida', // Valor por defecto
      ingredients:
          List<String>.from(json['ingredientes'] ?? []), // Manejo de null
      steps: List<String>.from(json['pasos'] ?? []), // Manejo de null
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