import 'package:cooking_hub/services/bing_services.dart';
import 'package:cooking_hub/services/openai_services.dart';
import 'package:flutter/material.dart';
import 'package:cooking_hub/services/google_maps_services.dart';
import 'package:cooking_hub/widgets/shared/background_image.dart';
import 'package:cooking_hub/widgets/shared/hot_bar.dart';
import 'package:cooking_hub/widgets/styles/textStyles.dart';
import 'package:cooking_hub/widgets/styles/containerStyle.dart';
import 'package:url_launcher/url_launcher.dart';

class Mercados extends StatefulWidget {
  const Mercados({super.key, required this.ingredients});
  final List<String> ingredients;

  @override
  State<StatefulWidget> createState() => _Mercados();
}

class _Mercados extends State<Mercados> {
  late Future<List<Map<String, dynamic>>> _mercadosFuture;

  @override
  void initState() {
    super.initState();
    _mercadosFuture = GoogleMapsServices().fetchNearbyMarkets();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const BackgroundImage(),
            Container(
              decoration: ContainerStyle.topContainerDec(),
              height: screenHeight * 0.1,
              width: screenWidth,
              alignment: Alignment.center,
              child: Text("Mercados", style: Textstyles.titleStyle()),
            ),
            Container(
              decoration: ContainerStyle.genContainerDec(),
              margin: EdgeInsets.only(top: screenHeight * 0.15),
              height: screenHeight,
              width: screenWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _mercadosFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator( color: Colors.white,));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                              child:
                                  Text('No se encontraron mercados cercanos.'));
                        } else {
                          return MercadosList(
                            mercados: snapshot.data!,
                            screenHeight: screenHeight,
                            bingServices: BingServices(),
                            ingredients: widget
                                .ingredients, // Pasamos el servicio de Bing
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            HotBar(),
          ],
        ),
      ),
    );
  }
}

class MercadosList extends StatelessWidget {
  const MercadosList({
    super.key,
    required this.mercados,
    required this.screenHeight,
    required this.bingServices,
    required this.ingredients,
  });

  final List<Map<String, dynamic>> mercados;
  final double screenHeight;
  final BingServices bingServices;
  final List<String> ingredients;

@override
Widget build(BuildContext context) {
  // Guardamos el Future en una variable local para que no se llame repetidamente.
  final Future<double> averagePriceFuture = 
      OpenAIService().calculateApproximatePrice(ingredients);

  return FutureBuilder<double>(
    future: averagePriceFuture, // Usamos el Future predefinido
    builder: (context, averageSnapshot) {
      String averagePrice = "\$..."; // Texto predeterminado mientras carga

      if (averageSnapshot.connectionState == ConnectionState.waiting) {
        averagePrice = "\$..."; // Cargando el promedio
      } else if (averageSnapshot.hasError) {
        averagePrice = "Error"; // Error al cargar
      } else if (averageSnapshot.hasData) {
        double? averageData = averageSnapshot.data;
        if (averageData != null && averageData > 0) {
          averagePrice = "\$${averageData.toStringAsFixed(2)}"; // Formateo
        } else {
          averagePrice = "NE"; // Si no hay promedio válido
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Texto del precio promedio centrado
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Text(
                  "Precio promedio",
                  style: Textstyles.titleStyle(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0), // Espaciado entre el texto y el precio
                Text(
                  averagePrice,
                  style: Textstyles.semiBoldStyle(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Lista de mercados con etiquetas personalizadas
          Expanded(
            child: ListView.builder(
              itemCount: mercados.length,
              itemBuilder: (context, index) {
                String currentName = mercados[index]['name'];
                double lat = mercados[index]['lat'];
                double lng = mercados[index]['lng'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (index == 0) ...[
                      Center(
                        child: Text(
                          "Recomendado",
                          style: Textstyles.titleStyle(),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                    if (index == 2) ...[
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Más opciones",
                          style: Textstyles.titleStyle(),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                    InkWell(
                      onTap: () {
                        _launchMaps(lat, lng);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0), // Separación entre botones
                        decoration: ContainerStyle.buttonContainerDec(),
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                currentName,
                                style: Textstyles.semiBoldStyle(),
                                overflow:
                                    TextOverflow.ellipsis, // Trunca el texto largo
                                maxLines: 1, // Solo muestra una línea
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      );
    },
  );
}



  // Método para abrir Google Maps con las coordenadas.
  void _launchMaps(double lat, double lng) async {
    final googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving';
    final Uri googleMapsUri = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri);
    } else {
      throw Exception('No se pudo abrir Google Maps.');
    }
  }
}
