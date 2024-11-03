import 'package:cooking_hub/domain/entities/recipe_model.dart';
import 'package:cooking_hub/services/database_services.dart';

class RecipesService {
  final DatabaseServices _dbService = DatabaseServices();

  Future<void> addRecipe(Recipe recipe) async {
    await _dbService.connect();
    await _dbService.recipesCollection.insertOne(recipe.toJson());
    await _dbService.close();
  }

  Future<List<Recipe>> getRecipes() async {
    await _dbService.connect();
    final recipesData = await _dbService.recipesCollection.find().toList();
    await _dbService.close();

    return recipesData.map((json) => Recipe.fromJson(json)).toList();
  }

}