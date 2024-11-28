import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class GoogleMapsServices {
  Future<List<Map<String, dynamic>>> getNearMarkets(double lat, double lng, {int radius = 2500}) async {
    String apiKey = dotenv.env['MAPS_API_KEY'] ?? 'Clave Maps no encontrada';
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=$radius&type=supermarket&key=$apiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final markets = data['results']
          .map<Map<String, dynamic>>((place) => {
                'name': place['name'],
                'lat': place['geometry']['location']['lat'],
                'lng': place['geometry']['location']['lng'],
              })
          .toList();
      return markets;
    } else {
      throw Exception('Error al obtener supermercados');
    }
  }

  Future<Position> getUserLocation() async {
    await _requestPermission(); // Solicita permisos de ubicacion

    return await Geolocator.getCurrentPosition();
  }

  Future<List<Map<String, dynamic>>> fetchNearbyMarkets() async {
    try {
      final position = await GoogleMapsServices().getUserLocation();
      // print(
      'Ubicacion del usuario: lat=${position.latitude}, lng=${position.longitude}';

      final markets = await GoogleMapsServices()
          .getNearMarkets(position.latitude, position.longitude);
      // print('Mercados obtenidos: $markets');

      return markets;
    } catch (e) {
      // print('Error: $e');
      throw Exception('Error al cargar los mercados cercanos: $e');
    }
  }

  Future<void> _requestPermission() async {
    // Verifica si los servicios de ubicacion están habilitados
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Los servicios de ubicación están deshabilitados.');
    }

    // Verifica si el permiso de ubicacion ha sido concedido
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Si el permiso es denegado, solicita el permiso
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Los permisos de ubicacion fueron denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Los permisos de ubicación estan permanentemente denegados.');
    }
  }

  

}


