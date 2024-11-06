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

    // Carga la imagen desde la camara
    final picker = ImagePicker();
    final image = await picker.pickImage(source: fuente);

    if (image == null) return 'Error al capturar imagen';

    //es necesario convertir la imagen a formato base 64
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
                {'type': 'LABEL_DETECTION', 'maxResults': 10}
              ]
            }
          ]
        }),
      );

       if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final labels = result['responses'][0]['labelAnnotations'] as List;
  
      // Filtra etiquetas basadas en un puntaje de confianza
      final filteredLabels = labels.where((label) => label['score'] > 0.7).map((label) => label['description']).toList();
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
}
