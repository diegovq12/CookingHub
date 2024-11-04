import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class GoogleVisionServices {
  String apikey = dotenv.env['GOOGLE_CLOUD_VISION_API_KEY'] ??
      'Api de cloud vision no encontrada';

  Future<String> detectIngredients() async {
  final picker = ImagePicker();
  final image = await picker.pickImage(source: ImageSource.camera);

  if (image == null) return 'Error al capturar imagen';

  final bytes = await File(image.path).readAsBytes();
  final base64Image = base64Encode(bytes);

  final url = 'https://vision.googleapis.com/v1/images:annotate?key=$apikey';

  final response = await http.post(
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
    final labels = result['responses'][0]['labelAnnotations'];

    // final detectedLabels = labels.map((label) => label['description']).join(', ');
    return labels;
  } else {

    return 'Error: ${response.statusCode} - ${response.reasonPhrase}';
  }
}
}
