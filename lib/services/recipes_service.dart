import 'package:cooking_hub/domain/entities/recipe_model.dart';
import 'package:cooking_hub/services/MongoDB.dart';

class RecipesService {
  
  static Future<void> addRecipe(Recipe recipe) async {
    await Mongodb.connecWhitMongo();
    await Mongodb.recipeCollection.insertOne(recipe.toJson());
    await Mongodb.closeConnection();
  }

  static Future<List<Recipe>> getRecipes() async {
    await Mongodb.connecWhitMongo();
    final recipesData = await Mongodb.recipeCollection.find().toList();
    await Mongodb.closeConnection();

    return recipesData.map((json) => Recipe.fromJson(json)).toList();
  }

}