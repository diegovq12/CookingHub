import 'dart:convert';
import 'package:http/http.dart' as http;


class OpenAIService {
  String apiKey = ""; 

  Future<String> sendTextCompletionRequest(String message) async {
    const String baseUrl = "https://api.openai.com/v1/chat/completions"; // Endpoint para GPT

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      "model": "gpt-3.5-turbo", // modelo que utilizamos para la conversación
      "messages": [
        {"role": "system", "content": "Eres un chef con alta experiencia en la cocina y gran habilidad para compartir tu conocimiento."},
        {
          "role": "user",
          "content": message
        } 
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
        // Utilizar utf8.decode para evitar problemas con caracteres especiales
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        String content = data['choices'][0]['message']['content'].trim();
        return content; 
      } else {
        return 'Error al obtener respuesta: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error de conexión.';
    }
  }
}
