import 'package:cooking_hub/services/bing_services.dart';
import 'package:flutter/material.dart';
import 'package:cooking_hub/services/google_maps_services.dart';
import 'package:cooking_hub/widgets/shared/background_image.dart';
import 'package:cooking_hub/widgets/shared/hot_bar.dart';
import 'package:cooking_hub/widgets/styles/textStyles.dart';
import 'package:cooking_hub/widgets/styles/containerStyle.dart';
import 'package:url_launcher/url_launcher.dart';

class Mercados extends StatefulWidget {
  const Mercados({super.key});

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
                          return Center(child: CircularProgressIndicator());
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
                            bingServices:
                                BingServices(), // Pasamos el servicio de Bing
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
    required this.bingServices, // Instancia de BingServices pasada desde el constructor
  });

  final List<Map<String, dynamic>> mercados;
  final double screenHeight;
  final BingServices bingServices; 

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mercados.length,
      itemBuilder: (context, index) {
        String currentName = mercados[index]['name'];
        double lat = mercados[index]['lat'];
        double lng = mercados[index]['lng'];

        return FutureBuilder<Map<String, double>>(
          future: bingServices.getPricesByMarket(
            [
              "leche",
              "huevos",
              "tomate",
              "jamon"
            ], // Lista de productos de prueba
            currentName
          ),
          builder: (context, priceSnapshot) {
            String price =
                "\$"; // Valor predeterminado si no se encuentra el precio
        

          

            return ListTile(
              title: Column(
                children: [
                  if (index == 0) ...[
                    Text("Recomendado", style: Textstyles.titleStyle()),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                  if (index == 2) ...[
                    Container(
                      alignment: Alignment.center,
                      child:
                          Text("Más opciones", style: Textstyles.titleStyle()),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                  InkWell(
                    onTap: () {
                      _launchMaps(lat, lng);
                    },
                    child: Container(
                      decoration: ContainerStyle.buttonContainerDec(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(currentName, style: Textstyles.semiBoldStyle()),
                          Text(price,
                              style: Textstyles
                                  .semiBoldStyle()), 
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            );
          },
        );
      },
    );
  }

// Metodo para abrir Google Maps con las coordenadas.
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
