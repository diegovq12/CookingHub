import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:image_picker/image_picker.dart';

class GoogleVisionServices {
  String apikey = dotenv.env['GOOGLE_CLOUD_VISION_API_KEY'] ??
      'Api de cloud vision no encontrada';

Future<String> detectIngredients(ImageSource fuente) async {
  final picker = ImagePicker();
  List<XFile> images;

  if (fuente == ImageSource.gallery) {
    images = await picker.pickMultiImage();
  } else {
    images = [];
    while (true) {
      final image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        images.add(image);
        if (images.length >= 5) break; // Ejemplo con límite de 5 fotos
      } else {
        break;
      }
    }
  }

  if (images.isEmpty) return 'Error: No se seleccionaron imágenes';

  final jsonString = await rootBundle.loadString('credencialescloud.json');
  final serviceAccount = ServiceAccountCredentials.fromJson(jsonString);
  final authClient = await clientViaServiceAccount(
    serviceAccount,
    ['https://www.googleapis.com/auth/cloud-platform'],
  );

  final url = 'https://vision.googleapis.com/v1/images:annotate';

  List<Map<String, dynamic>> requests = [];

  for (var image in images) {
    final bytes = await File(image.path).readAsBytes();
    final base64Image = base64Encode(bytes);

    requests.add({
      'image': {'content': base64Image},
      'features': [
        {
          'type': 'LABEL_DETECTION',
          'maxResults': 20
        }
      ]
    });
  }

  try {
    final response = await authClient.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'requests': requests}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      List<String> allIngredients = [];

      // Verificamos que haya respuestas para todas las imágenes
      if (result['responses'] == null || result['responses'].length != images.length) {
        return 'Error: La API no devolvió respuestas para todas las imágenes';
      }

      // Procesamos cada respuesta de forma independiente
      for (var i = 0; i < result['responses'].length; i++) {
        final labels = result['responses'][i]['labelAnnotations'] as List?;
        
        if (labels == null) {
          print('Advertencia: No se encontraron etiquetas para la imagen ${i + 1}');
          continue;
        }

        final filteredLabels = labels
            .where((label) => label['score'] > 0.85)
            .map((label) => label['description'] as String)
            .where((description) => _isIngredient(description))
            .where((description) => description.split(" ").length == 1)
            .toList();
        print("all ingredients $allIngredients");
        print("filtered labels $filteredLabels");

        allIngredients.addAll(filteredLabels);
      }

      final uniqueIngredients = allIngredients.toSet().toList();
      return uniqueIngredients.isNotEmpty
          ? uniqueIngredients.join(', ')
          : 'No se detectaron ingredientes específicos en ninguna imagen';
    } else {
      print('Error: ${response.statusCode} - ${response.reasonPhrase}');
      return 'Error: ${response.statusCode} - ${response.reasonPhrase}';
    }
  } catch (e) {
    print('Error al procesar las imágenes: $e');
    return 'Error al procesar las imágenes: $e';
  } finally {
    authClient.close();
  }
}



  // Verifica si la descripción contiene palabras clave relacionadas con alimentos
  bool _isIngredient(String description) {
    // Lista de categorías o palabras clave que se asocian con ingredientes
    final keywords = [
// Alimentos generales
      'fruit', 'vegetable', 'meat', 'dairy', 'grain', 'spice', 'herb',
      'seafood',
      'pasta', 'sauce', 'nut', 'bean', 'oil', 'fat', 'protein', 'sugar',
      'ingredient', 'food', 'drink', 'beverage', 'condiment', 'legume',
      'cereal',
      'snack', 'baking', 'dressing', 'syrup', 'honey', 'butter', 'jam', 'flour',
      'vinegar', 'salt', 'carbohydrate', 'protein', 'fiber', 'starch',

      // Proteinas
      'chicken', 'beef', 'pork', 'turkey', 'lamb', 'bacon', 'ham', 'salami',
      'sausage', 'pepperoni', 'tuna', 'salmon', 'shrimp', 'lobster', 'crab',
      'mussel',

      // Lacteos y derivados
      'milk', 'cream', 'yogurt', 'cheese', 'butter', 'cream cheese',
      'sour cream',
      'whipped cream', 'ice cream', 'condensed milk', 'evaporated milk',
      'parmesan',

      // Verduras
      'lettuce', 'spinach', 'kale', 'cabbage', 'carrot', 'celery', 'broccoli',
      'cauliflower', 'pepper', 'tomato', 'onion', 'garlic', 'potato', 'radish',
      'beet', 'zucchini', 'cucumber', 'pea', 'eggplant', 'squash', 'mushroom',

      // Frutas
      'apple', 'banana', 'orange', 'lemon', 'lime', 'grape', 'pineapple',
      'strawberry', 'blueberry', 'raspberry', 'peach', 'mango', 'kiwi',
      'cherry',
      'pear', 'plum', 'watermelon', 'melon', 'coconut', 'avocado',
      'pomegranate',

      // Granos y cereales
      'rice', 'quinoa', 'oat', 'corn', 'wheat', 'barley', 'bulgur', 'couscous',
      'spaghetti', 'macaroni', 'noodle', 'bread', 'tortilla', 'bagel',

      // Especias y condimentos
      'salt', 'pepper', 'cinnamon', 'nutmeg', 'ginger', 'paprika', 'turmeric',
      'cumin', 'oregano', 'basil', 'thyme', 'rosemary', 'saffron', 'chili',
      'clove', 'cardamom', 'vanilla', 'bay leaf', 'parsley', 'cilantro',

      // Otros ingredientes comunes
      'sugar', 'honey', 'maple syrup', 'molasses', 'chocolate', 'cocoa',
      'coffee',
      'tea', 'mustard', 'mayonnaise', 'ketchup', 'vinegar', 'yeast',
      'baking soda',
      'baking powder', 'gelatin', 'agar', 'cornstarch', 'soy sauce',
      'fish sauce',
      'olive oil', 'vegetable oil', 'canola oil', 'peanut butter',
      'almond butter',
    ];

    // Verifica si la descripción contiene alguna de las palabras clave
    return keywords
        .any((keyword) => description.toLowerCase().contains(keyword));
  }
}
