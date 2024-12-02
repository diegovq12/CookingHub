import 'package:cooking_hub/config/theme/app_theme.dart';
import 'package:cooking_hub/presentation/providers/chat_provider.dart';
import 'package:cooking_hub/presentation/screens/recetas.dart';
import 'package:cooking_hub/presentation/screens/start.dart';
import 'package:cooking_hub/services/MongoDB.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Cooking Hub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme(selectedColor: 0).theme(),
        home: const ConnectionHandler(), // Manejo de conexion inicial.
      ),
    );
  }
}

class ConnectionHandler extends StatelessWidget {
  const ConnectionHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Mongodb.ConnectWhitMongo(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFFFA832),
            body: Center(
              child: CircularProgressIndicator(color: Colors.white,), 
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 50),
                  const SizedBox(height: 20),
                  const Text(
                    "Error al conectar con la base de datos.",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Mongodb.ConnectWhitMongo(),
                    child: const Text("Reintentar"),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Recetas(); // Conexion exitosa.
        }
      },
    );
  }
}
