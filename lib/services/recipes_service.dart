
import 'package:cooking_hub/domain/entities/recipe_model.dart';
import 'package:cooking_hub/services/MongoDB.dart';

class RecipesService {
  
  static Future<void> addRecipe(Recipe recipe) async {
    await Mongodb.connecWhitMongo();
    
    // Convertir el nombre de la nueva receta a minúsculas
    final newRecipeNameLower = recipe.name.toLowerCase();

    // Buscar una receta con el mismo nombre en minúsculas
    final existingRecipe = await Mongodb.recipeCollection.findOne({
      'name': {'\$regex': '^${newRecipeNameLower}\$', '\$options': 'i'}
    });

    if (existingRecipe == null) {
      // Si no existe una receta con el mismo nombre (insensible a mayúsculas/minúsculas), la inserta
      await Mongodb.recipeCollection.insertOne(recipe.toJson());
      print("Receta agregada correctamente.");
    } else {
      // Si ya existe, no inserta la receta
      print("La receta con el mismo nombre ya existe.");
    }

    await Mongodb.closeConnection();
  }

  static Future<List<Recipe>> getRecipes() async {
    await Mongodb.connecWhitMongo();
    final recipesData = await Mongodb.recipeCollection.find().toList();
    await Mongodb.closeConnection();

    return recipesData.map((json) => Recipe.fromJson(json)).toList();
  }

}