import 'recipe_model.dart';

class User{
  final String userName;
  final String userEmail;
  final String password;
  final String profileImg;
  final List<String> favoriteIngredients; //Lista de ingredientes favoritos
  final List<List<String>> listOfIngredients; // Listas de ingredientes de recetas
  final List<Recipe> listFavoriteRecipes;

  const User({required this.userName,required this.userEmail, required this.password, required this.profileImg,
  required this.favoriteIngredients,required this.listOfIngredients,required this.listFavoriteRecipes});


  factory User.fromJson(Map<String,dynamic> json){
    return User(userName: json['userName'] as String? ?? 'Desconocido',
      userEmail: json['userEmail'] as String? ?? 'Desconocido',
      password: json['password'] as String? ?? 'Desconocido',
      profileImg: json['profileImg'] as String? ?? 'Desconocido',
      favoriteIngredients: 
        List<String>.from(json['favoriteIngredients']).toList() ??[],
      listOfIngredients: (json['listOfIngredients'] as List?)?.map((e) => List<String>.from(e as List)).toList()?? [[]],
      listFavoriteRecipes: (json['listFavoriteRecipes'] as List<dynamic>?)?.map((e)=> Recipe.fromJson(e as Map<String,dynamic>)).toList()??[]
      );
  }

  
  Map <String, dynamic> toJson(){
    return{
      'userName':userName,
      'userEmail':userEmail,
      'password':password,
      'profileImg':profileImg,
      'favoriteIngredients':favoriteIngredients,
      'listOfIngredients':listOfIngredients,
      'listFavoriteRecipes': listFavoriteRecipes.map((recipe) => recipe.toJson()).toList()
    };
  }

}