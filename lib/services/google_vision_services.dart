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
    // // Verifica y solicita el permiso de camara
    // var cameraStatus = await Permission.camera.status;
    // if (!cameraStatus.isGranted) {
    //   cameraStatus = await Permission.camera.request();
    //   if (!cameraStatus.isGranted) {
    //     return 'Error: Permiso de cámara denegado';
    //   }
    // }

    //  ? Carga la imagen desde la camara

    // Carga la imagen desde la camara
    final picker = ImagePicker();
    final image = await picker.pickImage(source: fuente);

    if (image == null) return 'Error al capturar imagen';

    // Convierte la imagen a formato base64
    final bytes = await File(image.path).readAsBytes();
    final base64Image = base64Encode(bytes);

    // Carga el archivo JSON con las credenciales de cuenta de servicio
    final jsonString = await rootBundle.loadString('credencialescloud.json');
    final serviceAccount = ServiceAccountCredentials.fromJson(jsonString);

    // Genera un cliente autenticado con el token
    final authClient = await clientViaServiceAccount(
      serviceAccount,
      ['https://www.googleapis.com/auth/cloud-platform'],
    );

    final url = 'https://vision.googleapis.com/v1/images:annotate';

    try {
      final response = await authClient.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'requests': [
            {
              'image': {'content': base64Image},
              'features': [
                {
                  'type': 'LABEL_DETECTION',
                  'maxResults': 20
                } // Aumentar resultados
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final labels = result['responses'][0]['labelAnnotations'] as List;

        // Aplicación de múltiples filtros
        final filteredLabels = labels
            .where(
                (label) => label['score'] > 0.7) // Filtro de puntaje más alto
            .map((label) => label['description'])
            .where((description) => _isIngredient(
                description)) // Filtro por categorías de alimentos
            .where((description) =>
                description.split(" ").length ==
                1) // Filtro de una sola palabra
            .toList();

        print('Labels $filteredLabels');
        return filteredLabels.isNotEmpty
            ? filteredLabels.join(', ')
            : 'No se detectaron ingredientes específicos';
      } else {
        return 'Error: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Error al procesar la imagen: $e';
    } finally {
      authClient.close();
    }
  }

  // Verifica si la descripción contiene palabras clave relacionadas con alimentos
  bool _isIngredient(String description) {
    // Lista de categorías o palabras clave que se asocian con ingredientes
    final keywords = [

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

      // Alimentos generales
      // 'fruit', 'vegetable', 'meat', 'dairy', 'grain', 'spice', 'herb',
      // 'seafood',
      // 'pasta', 'sauce', 'nut', 'bean', 'oil', 'fat', 'protein', 'sugar',
      // 'ingredient', 'food', 'drink', 'beverage', 'condiment', 'legume',
      // 'cereal',
      // 'snack', 'baking', 'dressing', 'syrup', 'honey', 'butter', 'jam', 'flour',
      // 'vinegar', 'salt', 'carbohydrate', 'protein', 'fiber', 'starch',
      // 'vitamin'
    ];

    // Verifica si la descripción contiene alguna de las palabras clave
    return keywords
        .any((keyword) => description.toLowerCase().contains(keyword));
  }
}