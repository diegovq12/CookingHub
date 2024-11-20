import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

class BingServices {
  String apiKey = dotenv.env['BING_API_KEY'] ?? 'Clave OpenAI no encontrada';
  final endpoint = 'https://api.bing.microsoft.com/v7.0/search';

  Future<Map<String, double>> getProductsPrice(
      List<String> products, String market) async {
    Map<String, double> preciosPorProducto = {};
    print("Mercado: $market");
    // Iterar sobre los productos
    for (String product in products) {
      final query = '$product precio en $market, solamente quiero saber precio';
      final url = Uri.parse('$endpoint?q=$query');
      final headers = {
        'Ocp-Apim-Subscription-Key': apiKey,
      };

      try {
        final response = await http.get(url, headers: headers);

        // Validar respuesta de la API
        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          // Validar si existen resultados en la API
          if (data['webPages'] != null && data['webPages']['value'] != null) {
            final resultados = data['webPages']['value'];
            print(resultados);
            // Intentar extraer precio valido
            double? precioValido = _extractValidPrice(resultados);

            if (precioValido != null) {
              preciosPorProducto[product] = precioValido;
            } else {
              // Si no se encuentra precio valido, ignorar este producto
              print(
                  "No se encontró un precio valido para $product en $market.");
            }
          } else {
            print("Sin resultados relevantes para $product en $market.");
          }
        } else {
          print("Error en la API: ${response.statusCode}");
        }
      } catch (e) {
        print("Error al consultar precios: $e");
      }
    }

    print("Precios encontrados: $preciosPorProducto");
    return preciosPorProducto;
  }

// Función para extraer un precio valido de los resultados
  double? _extractValidPrice(List<dynamic> resultados) {
    for (var resultado in resultados) {
      final snippet = resultado['snippet'];
      final priceString = _getPriceFromString(snippet);

      if (priceString != null) {
        final price = double.tryParse(priceString);

        // Validar precios dentro de un rango razonable
        if (price != null && price > 0 && price < 10000) {
          return price;
        }
      }
    }
    return null; // Si no se encuentra un precio valido
  }

  String? _getPriceFromString(String texto) {
    // Regex para capturar numeros con contexto claro de precio
    final regex = RegExp(
        r'(?:(?:\$|MXN|USD|precio:?)\s?\d{1,3}(?:[,\.]\d{3})*(?:\.\d{1,2})?)');
    final match = regex.firstMatch(texto);

    if (match != null) {
      String matchedPrice = match.group(0)!;
      matchedPrice = matchedPrice.replaceAll(
          RegExp(r'[^\d.]'), ''); // Limpiar caracteres extraños
      return matchedPrice;
    }

    return null; // Retornar nulo si no hay coincidencias validas
  }
}
