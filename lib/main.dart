// import 'package:cooking_hub/config/theme/app_theme.dart';
// import 'package:cooking_hub/presentation/providers/chat_provider.dart';
// import 'package:cooking_hub/presentation/screens/chat_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {

//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => ChatProvider())
//       ],
//       child: MaterialApp(
//         title: 'Cooking Hub',
//         debugShowCheckedModeBanner: false,
//         theme:AppTheme(selectedColor: 2).theme(),
//         home: const ChatScreen()
//         ),
//     );

//   }
// }

import 'package:mongo_dart/mongo_dart.dart';
import 'package:cooking_hub/domain/entities/user_model.dart';
import 'services/user_service.dart';
import 'domain/Connection/MongoDB.dart';
import 'domain/Connection/Temp.dart';

void main() async {
  final List<String> listIng = ([
    'Apio',
    'Chicolate',
    'Pechuga de pollo',
    'Manzana',
    'Almendras',
    'Frijoles'
  ]);
  final List<List<String>> lalista = ([]);
  final prueba = User(
      userName: 'Guest',
      userEmail: 'Guest@gmail.com',
      password: 'guest',
      profileImg: 'link',
      favoriteIngredients: listIng,
      listOfIngredients: lalista);
  await UserService.addUser(prueba);
}
