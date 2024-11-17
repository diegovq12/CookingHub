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
    for (String product in products) {
      final query = '$product $market precio';
      final url = Uri.parse('$endpoint?q=$query');
      final headers = {
        'Ocp-Apim-Subscription-Key': apiKey,
      };
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final resultados = data['webPages']['value'];
        for (var resultado in resultados) {
          final snippet = resultado['snippet'];
          final price = _getPriceFromString(snippet);
          if (price != null) {
            preciosPorProducto[product] = double.parse(price);
            break;
          }
        }
      }
    }
    return preciosPorProducto;
  }


// honestamente no entiendo completamente esto pero chatsito me dijo que era una buena manera de extraer 
// el precio de la respuesta de bing
  String? _getPriceFromString(String texto) {
    final regex = RegExp(r'(\d+(\.\d{1,2})?)');
    final match = regex.firstMatch(texto);
    return match?.group(0);
  }

  Map<String, double> getTotalByMarket(
      Map<String, Map<String, double>> priceByMarket) {
    Map<String, double> totalByMarket = {};

    priceByMarket.forEach((market, products) {
      final total = products.values.reduce((a, b) => a + b);
      totalByMarket[market] = total;
    });

    return totalByMarket;
  }

  String? findBestMarket(Map<String, double> totalByMarket) {
    String? bestMarket;
    double minPrice = double.infinity;

    totalByMarket.forEach((market, total) {
      if (total < minPrice) {
        minPrice = total;
        bestMarket = market;
      }
    });

    return bestMarket;
  }


Future<Map<String, double>> getPricesByMarket(List<String> products, String marketName) async {
  // Obtener coordenadas del mercado a partir del nombre utilizando la API de Google Maps
  Map<String, double> pricesByMarket = {};

  try {
    // Obtener precios de productos para este mercado
    Map<String, double> productsPrice = await getProductsPrice(products, marketName);

    // Sumar precios de productos para calcular el total en el supermercado
    final total = productsPrice.values.reduce((a, b) => a + b);
    pricesByMarket[marketName] = total;
  } catch (e) {
    logger.d('Error al obtener precios para $marketName: $e');
  }

  return pricesByMarket;
}

}
