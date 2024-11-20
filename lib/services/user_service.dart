import 'MongoDB.dart';
import 'package:cooking_hub/domain/entities/user_model.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:cooking_hub/domain/entities/recipe_model.dart';


class UserService {
  static Future<void> addUser(User newUser) async {
    await Mongodb.ConnectWhitMongo();
    await Mongodb.insertUser(newUser.toJson());
    await Mongodb.closeConnection();
  }

  static Future<User?> getUsers(String id) async{
    await Mongodb.ConnectWhitMongo();
    final userRecovery = await Mongodb.userCollection;
    var userResult = await userRecovery.findOne(where.id(ObjectId.parse(id)));
    await Mongodb.closeConnection();

    if(userResult != null){
      return User.fromJson(userResult);
    }
    return null;
  }

  

  //Agrega un nuevo ingrediente a la lista de ingredientes fav
  static Future<void> addNewIngredientsFavorites(String id, String newIngredient) async{
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)),modify.push('favoriteIngredients', newIngredient));
    await Mongodb.closeConnection();
  }

  //Agrega una nueva lista a la lista de recetas
  static Future<void> addNewListOfIngredients(String id,List<String> newList) async{
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)), modify.push('listOfIngredients', newList));
    await Mongodb.closeConnection();
  }

  //Modifica un elemento de la una de las listas de ingredientes
  static Future<void> modifyListOfIngredients(String id, List<String> newList, int indexList) async{
    String listCon = 'listOfIngredients.' + indexList.toString();
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)), modify.set(listCon, newList));
    await Mongodb.closeConnection();
  }

  //Elimina un de las lista de ingredientes
  static Future<void> deleteOneListOfIngredients(String id, List<String> removeList) async{
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)), modify.pull('listOfIngredients',removeList));
    await Mongodb.closeConnection();
  }

  //Modifica un solo ingrediente de una de las lista de ingredientes
  static Future<void> modifyIngredientInList(String id, int indexPrimaryList, int indexSecondaryList, String newIngredient) async{
    String listCon = 'listOfIngredients.' + indexPrimaryList.toString() + '.' + indexSecondaryList.toString();
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)), modify.set(listCon, newIngredient));
    await Mongodb.closeConnection();
  }
  //Elimina un solo ingrediente de una lista de recetas
  static Future<void> deleteIngredientInList(String id, int indexPrimaryList, String removeIngredient) async{
    String listCon = 'listOfIngredients.' + indexPrimaryList.toString();
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)), modify.pull(listCon, removeIngredient));
    await Mongodb.closeConnection();
  }

  // ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  //Aniade una nueva receta a la lista de recetas favoritas
  // ID USUARIO = "
  // 673516bd55397c8475000000
  // "
  static Future<void> addFavoriteRecipe(String id, Recipe newRecipe) async{
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)), modify.push('listFavoriteRecipes', newRecipe.toJson()));
    await Mongodb.closeConnection();
  }

  //Elimina una receta de la lista de favortitas
  static Future<void> deleteFavoriteRecipe(String id, Recipe deleteRecipe) async{
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)), modify.pull('listFavoriteRecipes', deleteRecipe.toJson()));
    await Mongodb.closeConnection();
  }

  //Modifica algun elemento de una receta favorita
  // id = usuario , primaryIndex = indice receta , Space = {nombre, ingrediente ,campo etc}, Newdata= remplazco, secondaryIndex = indice del ingrediente/paso (start=0) 
  static Future<void> modifyElementOfFavoriteList(String id,int primaryIndex, String space, String newData,[int? secondaryIndex]) async{
    await Mongodb.ConnectWhitMongo();
    if(secondaryIndex != null){
      String listCon = 'listFavoriteRecipes.' + primaryIndex.toString()+"."+space+"."+secondaryIndex.toString();
      await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)), modify.set(listCon, newData));
    }else{
      String listCon = 'listFavoriteRecipes.' + primaryIndex.toString()+"."+space;
      await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)), modify.set(listCon, newData));
    }
    await Mongodb.closeConnection();
  }

  //Elimina un elemento de los ingredientes o los pasos
  static Future<void> deleteOfListIngredients_Steps(String id, int primaryIndex, String space,String itemToDelete) async{
    String listCon = 'listFavoriteRecipes.' + primaryIndex.toString() +"."+ space.toString();
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)),modify.pull(listCon, itemToDelete));
    await Mongodb.closeConnection();
  }

  static Future<void> addOfIngredients_Steps(String id, int primaryIndex, String space, String newItem) async{
    String listCon = 'listFavoriteRecipes.$primaryIndex.$space';
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)), modify.push(listCon, newItem));
    await Mongodb.closeConnection();
  }

}
