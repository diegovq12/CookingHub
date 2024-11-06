import 'dart:convert';
import 'package:cooking_hub/services/database_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  String apiKey = dotenv.env['OPENAI_API_KEY'] ?? 'Clave OpenAI no encontrada';

Future<String> sendTextCompletionRequest(String message) async {
  const String baseUrl = "https://api.openai.com/v1/chat/completions";

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  final body = jsonEncode({
    "model": "gpt-3.5-turbo",
    "messages": [
      {
        "role": "system",
        "content": "Este asistente solo proporciona ayuda con temas de cocina. Responde exclusivamente a preguntas relacionadas con recetas de cocina. Si el mensaje contiene temas inapropiados o no culinarios, responde con: 'Este asistente solo proporciona ayuda con temas de cocina.' Si la solicitud es culinaria, responde con los campos: nombre, region, ingredientes, y pasos en formato JSON.'"
      },
      {"role": "user", "content": message}
    ],
    "max_tokens": 450,
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

      // Verifica contenido no culinario
      if (content.contains("Este asistente solo proporciona ayuda con temas de cocina")) {
        return content;
      }

      try {
        final jsonData = jsonDecode(content);

        if (jsonData.containsKey('nombre') &&
            jsonData.containsKey('region') &&
            jsonData.containsKey('ingredientes') &&
            jsonData.containsKey('pasos')) {
          
          Map<String, dynamic> recipe = {
            'name': jsonData['nombre'],
            'region': jsonData['region'],
            'ingredients': jsonData['ingredientes'],
            'steps': jsonData['pasos'],
          };

          // Insertar en la base de datos
          final dbService = DatabaseServices();
          await dbService.connect();
          await dbService.insertRecipe(recipe);
          await dbService.close();
          // print('Content: $content');
          return content;
        } else {
          return "Este asistente está diseñado solo para ayudarte con temas culinarios.";
        }
      } catch (e) {
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
