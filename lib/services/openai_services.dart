import 'dart:convert';
import 'package:cooking_hub/domain/entities/recipe_model.dart';
import 'recipes_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class OpenAIService {
  String apiKey = dotenv.env['OPENAI_API_KEY'] ?? 'Clave OpenAI no encontrada';

Future<String> sendTextCompletionRequest(String message) async {
  const String baseUrl = "https://api.openai.com/v1/chat/completions";

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  var logger = Logger();
  logger.d('Diebug Mensaje: $message');

  final body = jsonEncode({
    "model": "gpt-3.5-turbo",
    "messages": [
      {
        "role": "system",
        "content": "responde con los campos: nombre, region, ingredientes, y pasos en formato JSON. Si no tiene que ver con comida no devuelvas formato JSON"
      },
      {"role": "user", "content": message}
    ],
    "max_tokens": 550,
    "temperature": 0.7,
  });
  try {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      String content = data['choices'][0]['message']['content'].trim();

      logger.d('Diebug contenido: $content');
      final jsonData = jsonDecode(content);

      if (jsonData.containsKey('nombre') ||
          jsonData.containsKey('region') ||
          jsonData.containsKey('ingredientes') &&
          jsonData.containsKey('pasos')) {
        
          Recipe recipe = Recipe(
          name: jsonData['nombre'],
          region: jsonData['region'],
          ingredients: List<String>.from(jsonData['ingredientes']),
          steps: List<String>.from(jsonData['pasos']),
          );

          // Insertar en la base de datos
          await RecipesService.addRecipe(recipe);

          logger.d('Diebug contenido despues de base de datos: $content');
          return content;
      } else {
        return "Este asistente está diseñado solo para ayudarte con temas culinarios.";
      }
    } else {
      return 'Error al obtener respuesta: ${response.statusCode}';
    }
  } catch (e) {
    return 'Error de conexión.';
  }
}

  String naturalLanguageResponse(String jsonResponse) {
    final recipeData = json.decode(jsonResponse);

    final recipeName = recipeData['nombre'] ?? 'Receta sin nombre';
    String region = recipeData['region'] ?? 'Región desconocida';
    List<String> ingredients =
        List<String>.from(recipeData['ingredientes'] ?? []);
    List<String> steps = List<String>.from(recipeData['pasos'] ?? []);

    String response = "¡Claro! Aqui tienes la receta de $recipeName\n";
    response += "Region de la receta: $region.\n";
    response += "Ingredientes:\n";
    for (var ingredient in ingredients) {
      response += "- $ingredient\n";
    }
    response += "\nPasos:\n";

    for (var i = 0; i < steps.length; i++) {
      response += "${i + 1}. ${steps[i]}\n";
    }

    response +=
        "\n¡Espero que disfrutes esta deliciosa receta de $recipeName! Si tienes alguna otra pregunta o si quieres aprender a preparar otro plato, ¡no dudes en decirme!";
    return response;
  }

 
}
