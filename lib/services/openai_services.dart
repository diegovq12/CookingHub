import 'dart:convert';
import 'package:cooking_hub/services/database_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  String apiKey = dotenv.env['OPENAI_API_KEY'] ?? 'Clave OpenAI no encontrada';

  Future<String> sendTextCompletionRequest(String message) async {
    const String baseUrl =
        "https://api.openai.com/v1/chat/completions"; // Endpoint para GPT

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      "model": "gpt-3.5-turbo", // modelo que utilizamos para la conversación
      "messages": [
        {
          "role": "system",
          "content":
              "Si el mensaje esta relacionado con cocina responder con nombre, region,ingredientes, pasos. En formato JSON,"
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
        String contentJson = content;
        final jsonData = jsonDecode(contentJson);

        Map<String, dynamic> recipe = {
          'name': jsonData['nombre'],
          'region': jsonData['region'],
          'ingredients': jsonData['ingredientes'],
          'steps': jsonData['pasos'],
        };

        // Inicializar el servicio de base de datos y conectar
        final dbService = DatabaseServices();
        await dbService.connect();

        // Insertar la receta en la base de datos
        await dbService.insertRecipe(recipe);

        // Cerrar la conexion
        await dbService.close();
        // print(content);
        return content;
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

  // Future<String> generateRecipeFromImage(String message) {
  //   const String baseUrl =
  //       "https://api.openai.com/v1/chat/completions"; // Endpoint para GPT

  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $apiKey',
  //   };

  //   final body = jsonEncode({
  //     "model": "gpt-3.5-turbo", // modelo que utilizamos para la conversación
  //     "messages": [
  //       {
  //         "role": "system",
  //         "content":
  //             "Responder con nombre, region,ingredientes, pasos. En formato JSON"
  //       },
  //       {"role": "user", "content": message}
  //     ],
  //     "max_tokens": 450,
  //     "temperature": 0.7,
  //   });

  //   try{
  //       final response = await http.post(
  //       Uri.parse(baseUrl),
  //       headers: headers,
  //       body: body,
  //     );

  //     if(response.statusCode == 200){
  //       final data = jsonDecode(utf8.decode(response.bodyBytes));
  //       String content = data['choices'][0]['message']['content'].trim();
  //       String contentJson = content;
  //       final jsonData = jsonDecode(contentJson);
  //     }

  //     return content;
  //   }catch(e){
  //     return 'Error de conexion $e';
  //   }

  // }
}
