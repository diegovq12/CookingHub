import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:image_picker/image_picker.dart';

class GoogleVisionServices {
  String apikey = dotenv.env['GOOGLE_CLOUD_VISION_API_KEY'] ??
      'Api de cloud vision no encontrada';

  Future<String> detectIngredients() async {
    // Carga la imagen desde la cámara
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return 'Error al capturar imagen';

    final bytes = await File(image.path).readAsBytes();
    final base64Image = base64Encode(bytes);

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

        // Aplicacion de múltiples filtros
        final filteredLabels = labels
            .where(
                (label) => label['score'] > 0.85) // Filtro de puntaje mas alto
            .map((label) => label['description'])
            .where((description) => _isIngredient(
                description)) // Filtro por categorias de alimentos
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

  bool _isIngredient(String description) {
    // Lista de filtros de palabras clave
    final keywords = [
      'fruit',
      'vegetable',
      'meat',
      'dairy',
      'grain',
      'spice',
      'herb',
      'seafood',
      'pasta',
      'sauce',
      'nut',
      'bean',
      'oil',
      'fat',
      'protein',
      'sugar',
      'ingredient',
      'food',
      'drink',
      'beverage',
      'condiment',
      'legume',
      'cereal',
      'snack',
      'baking',
      'dressing',
      'syrup',
      'honey',
      'butter',
      'jam',
      'flour',
      'vinegar',
      'salt',
      'carbohydrate'
    ];

    // Verificar si la descripcion contiene alguna de las palabras filtro
    return keywords
        .any((keyword) => description.toLowerCase().contains(keyword));
  }
}
