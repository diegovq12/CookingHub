import 'MongoDB.dart';
import 'package:cooking_hub/domain/entities/user_model.dart';
import 'package:mongo_dart/mongo_dart.dart';



class UserService {
  static Future<void> addUser(User newUser) async {
    await Mongodb.ConnecWhitMongo();
    await Mongodb.insertUser(newUser.toJson());
    await Mongodb.closeConnection();
  }

  static Future<User?> getUsers(String id) async{
    await Mongodb.ConnecWhitMongo();
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
    await Mongodb.ConnecWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)),modify.push('favoriteIngredients', newIngredient));
    await Mongodb.closeConnection();
  }

  //Agrega una nueva lista a la lista de recetas
  static Future<void> addNewListOfIngredients(String id,List<String> newList) async{
    await Mongodb.ConnecWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)), modify.push('listOfIngredients', newList));
    await Mongodb.closeConnection();
  }

  //Modifica un elemento de la una de las listas de ingredientes
  static Future<void> modifyListOfIngredients(String id, List<String> newList, int indexList) async{
    String listCon = 'listOfIngredients.' + indexList.toString();
    await Mongodb.ConnecWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)), modify.set(listCon, newList));
    await Mongodb.closeConnection();
  }

  //Elimina un de las lista de ingredientes
  static Future<void> deleteOneListOfIngredients(String id, List<String> removeList) async{
    await Mongodb.ConnecWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)), modify.pull('listOfIngredients',removeList));
    await Mongodb.closeConnection();
  }

  //Modifica un solo ingrediente de una de las lista de ingredientes
  static Future<void> modifyIngredientInList(String id, int indexPrimaryList, int indexSecondaryList, String newIngredient) async{
    String listCon = 'listOfIngredients.' + indexPrimaryList.toString() + '.' + indexSecondaryList.toString();
    await Mongodb.ConnecWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)), modify.set(listCon, newIngredient));
    await Mongodb.closeConnection();
  }
  //Elimina un solo ingrediente de una lista de recetas
  static Future<void> deleteIngredientInList(String id, int indexPrimaryList, String removeIngredient) async{
    String listCon = 'listOfIngredients.' + indexPrimaryList.toString();
    await Mongodb.ConnecWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)), modify.pull(listCon, removeIngredient));
    await Mongodb.closeConnection();
  }
}
