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


Future<double> calculateApproximatePrice(List<String> products) async {
  const String baseUrl = "https://api.openai.com/v1/chat/completions";

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey', 
  };

  var logger = Logger();
  logger.d('Diebug Productos: $products');

  final body = jsonEncode({
    "model": "gpt-3.5-turbo", 
    "messages": [
      {
        "role": "system",
        "content": "Eres un experto en precios de mercado, especialmente en productos comunes como alimentos y artículos de uso diario. "
                   "Calcula el precio aproximado de cada producto en la lista proporcionada, usando tus conocimientos sobre precios promedio de mercado "
                   "y factores de variación según la ubicación y temporada. Asegúrate de proporcionar el precio de cada producto de acuerdo a su cantidad en formato de lista. "
                   "Responde estrictamente en formato JSON con los productos y sus precios individuales en pesos mexicanos. Ejemplo: "
                   "{\"fresas\": 30, \"leche\": 15, \"crema batida\": 25}"
      },
      {
        "role": "user",
        "content": "Calcular el precio aproximado de los siguientes productos: ${products.join(', ')}"
      }
    ],
    "max_tokens": 200,
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

      logger.d('Diebugprice contenido: $content'); 

      // Intentamos parsear la respuesta de OpenAI
      try {
        final jsonData = jsonDecode(content);

        if (jsonData != null && jsonData is Map) {
          double totalPrice = 0.0;

          // Recorremos los precios de los productos en la respuesta y los sumamos
          jsonData.forEach((product, price) {
            if (price is double || price is int) {
              totalPrice += price.toDouble();
            } else {
              logger.w('Diebugprice Precio no válido para el producto $product: $price');
            }
          });

          // Validamos que el total no sea cero o irreal
          if (totalPrice > 0) {
            return totalPrice;
          } else {
            logger.w('Diebugprice Total calculado es 0 o inválido.');
            return 0.0;
          }
        } else {
          logger.w('Diebugprice Respuesta JSON no tiene formato válido: $jsonData');
          return 0.0;
        }
      } catch (jsonError) {
        logger.e('Diebugprice Error al decodificar JSON: $jsonError');
        return 0.0;
      }
    } else {
      logger.e('Error en la API: ${response.statusCode} - ${response.body}');
      return 0.0;
    }
  } catch (e) {
    logger.e('Diebugprice Error calculando el precio: $e');
    return 0.0;
  }
}
 
}
