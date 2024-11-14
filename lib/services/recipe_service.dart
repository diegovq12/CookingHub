import 'MongoDB.dart';
import 'package:cooking_hub/domain/entities/recipe_model.dart';
//import 'package:mongo_dart/mongo_dart.dart';

class RecipeService {

  static Future<void> addRecipe(Recipe newRecipe) async{
    await Mongodb.ConnectWhitMongo();
    await Mongodb.insertRecipe(newRecipe.toJson());
    await Mongodb.closeConnection();
  }


  
}

