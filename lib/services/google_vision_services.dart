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
    // Carga la imagen desde la cámara
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
                {'type': 'LABEL_DETECTION', 'maxResults': 30}
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
            .where((label) =>
                label['score'] > 0.6) // Ajustado para incluir más etiquetas
            .map((label) => label['description'])
            .where((description) => _isIngredient(
                description)) // Filtro por categorías de alimentos
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

  bool _isIngredient(String description) {
    // Lista de ingredientes
    final keywords = [
      'chicken',
      'beef',
      'pork',
      'turkey',
      'lamb',
      'bacon',
      'ham',
      'salami',
      'sausage',
      'pepperoni',
      'tuna',
      'salmon',
      'shrimp',
      'lobster',
      'crab',
      'mussel',
      'milk',
      'cream',
      'yogurt',
      'cheese',
      'butter',
      'lettuce',
      'spinach',
      'carrot',
      'celery',
      'broccoli',
      'tomato',
      'onion',
      'garlic',
      'potato',
      'apple',
      'banana',
      'orange',
      'lemon',
      'lime',
      'rice',
      'quinoa',
      'oat',
      'corn',
      'wheat',
      'salt',
      'pepper',
      'cinnamon',
      'nutmeg',
      'ginger',
      'paprika',
      'turmeric',
      'oregano',
      'basil',
      'thyme',
      'rosemary',
      'saffron',
      'chili',
      'clove',
      'cardamom',
      'vanilla',
      'sugar',
      'honey',
      'maple syrup',
      'chocolate',
      'olive oil',
      'vegetable oil',
      'canola oil',
      'peanut butter',
      'almond butter',
    ];

    // Verifica si la descripción contiene alguna de las palabras clave
    return keywords
        .any((keyword) => description.toLowerCase().contains(keyword));
  }
}
