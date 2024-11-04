import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class GoogleVisionServices {
  String apikey = dotenv.env['GOOGLE_CLOUD_VISION_API_KEY'] ??
      'Api de cloud vision no encontrada';

  Future<void> detectIngrediens() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    // Convierte la imagen a base64
    final bytes = await File(image.path).readAsBytes();
    final base64Image = base64Encode(bytes);

    final url = 'https://vision.googleapis.com/v1/images:annotate?key=$apikey';

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'request': [
            {
              'image': {'content': base64Image},
              'features': [
                {'type': 'LABEL_DETECTION', 'maxResults': 10}
              ]
            }
          ]
        }));

        if(response.statusCode == 200){
          final result = jsonDecode(response.body);
          final labels = result['responses'][0]['labelAnnotations'];

          print("Ingredientes detectados: ");
          for(var label in labels){
            print(label['description']);
          }
        }else{
          print('Error: ${response.reasonPhrase}');
        }
  }
}
