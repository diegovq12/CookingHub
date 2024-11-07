import 'package:cooking_hub/config/theme/app_theme.dart';
import 'package:cooking_hub/presentation/providers/chat_provider.dart';
// import 'package:cooking_hub/presentation/screens/chatBot.dart';
// import 'package:cooking_hub/presentation/screens/chat_screen.dart';
// import 'package:cooking_hub/presentation/screens/ingredientes.dart';
// import 'package:cooking_hub/presentation/screens/chat_screen.dart';
// import 'package:cooking_hub/presentation/screens/recetas.dart';
// import 'package:cooking_hub/presentation/screens/favoritos.dart';
import 'package:cooking_hub/presentation/screens/ingredientes.dart';
// import 'package:cooking_hub/presentation/screens/recetas.dart';
// import 'package:cooking_hub/presentation/screens/recetasDetectadas.dart';
import 'package:cooking_hub/presentation/screens/logic.dart';
// import 'package:cooking_hub/presentation/screens/recetasDetectadas.dart';
// import 'package:cooking_hub/presentation/screens/chatBot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: ChatScreen(),
    // );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatProvider())
      ],
      child: MaterialApp(
        title: 'Cooking Hub',
        debugShowCheckedModeBanner: false,
        theme:AppTheme(selectedColor: 2).theme(),
        home: ingredientes()
        ),
    );

  }
}
