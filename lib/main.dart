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

import 'services/user_service.dart';


void main() async {
  var result = await UserService.getUsers('672842c9368c80edf2000000');
  if(result != null){
    print("Registro encontrado:");
    print('Name: ${result.userName}');
    print('Email: ${result.userEmail}');
    print('Ingredientes: ${result.favoriteIngredients}');
    print('Listas de ingredientes: ${result.listOfIngredients}');

  }
}
