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

import 'package:cooking_hub/domain/entities/recipe_model.dart';

import 'package:cooking_hub/domain/entities/user_model.dart';
import 'package:cooking_hub/services/recipe_service.dart';
// import 'services/user_service.dart';
import 'package:cooking_hub/services/user_service.dart';

void main() async {
  // User? newUser = await UserService.getUsers("673516bd55397c8475000000");
  // Recipe receta = newUser!.listFavoriteRecipes[2];
  

  
  // Recipe newRecipe = Recipe(name: "Yogurth", region: "Piltover", ingredients: [
  //   "Bacterias",
  //   "Leche",
  //   "Fresas",
  //   "Hijos del tonito"
  // ], steps: [
  //   "Cuando yogurth mama y yogurth papa se quieren mucho copulan para dar lugar a un yogurht hijo"
  // ]);

  // await UserService.addOfIngredients_Steps(
  //     '673516bd55397c8475000000', 1, "steps", "Partir las fresas");

  // String id = '672842c9368c80edf2000000';
  // var result = await UserService.getUsers(id);
  // // if(result != null){
  // //   print("Registro encontrado:");
  // //   print('Name: ${result.userName}');
  // //   print('Email: ${result.userEmail}');
  // //   print('Ingredientes: ${result.favoriteIngredients}');
  // //   print('Listas de ingredientes: ${result.listOfIngredients}');
  // // }

  //  String newIngredient = 'Lechuga';
  //  Recipe newRecipe = Recipe(name: 'Caldo de res', region: 'Mexico', ingredients: ['Ingredientes'], steps: ['Pasos']);
  //  await RecipeService.addRecipe(newRecipe);
  //  await UserService.addNewIngredientsFavorites(id, newIngredient);

  //  await UserService.addNewListOfIngredients(id, ['Una prueba']);
}
