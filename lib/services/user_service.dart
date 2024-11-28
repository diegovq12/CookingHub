import 'package:bcrypt/bcrypt.dart';

import 'MongoDB.dart';
import 'package:cooking_hub/domain/entities/user_model.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:cooking_hub/domain/entities/recipe_model.dart';

class UserService {
  String userId = "";

  String getId(){
    return userId;
  }

  static Future<void> addUser(User newUser) async {
    await Mongodb.ConnectWhitMongo();
    await Mongodb.insertUser(newUser.toJson());
    await Mongodb.closeConnection();
  }

  static Future<User?> getUsers(String id) async {
    await Mongodb.ConnectWhitMongo();
    final userRecovery = await Mongodb.userCollection;
    var userResult = await userRecovery.findOne(where.id(ObjectId.parse(id)));
    await Mongodb.closeConnection();

    if (userResult != null) {
      return User.fromJson(userResult);
    }
    return null;
  }

  //Agrega un nuevo ingrediente a la lista de ingredientes fav
  static Future<void> addNewIngredientsFavorites(
      String id, String newIngredient) async {
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)),
        modify.push('favoriteIngredients', newIngredient));
    await Mongodb.closeConnection();
  }

  


  //Modifica un elemento de la una de las listas de ingredientes
  static Future<void> modifyListOfIngredients(
      String id, List<String> newList, int indexList) async {
    String listCon = 'listOfIngredients.' + indexList.toString();
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection
        .updateOne(where.id(ObjectId.parse(id)), modify.set(listCon, newList));
    await Mongodb.closeConnection();
  }

  //Elimina un de las lista de ingredientes
  static Future<void> deleteOneListOfIngredients(
      String id, List<String> removeList) async {
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)),
        modify.pull('listOfIngredients', removeList));
    await Mongodb.closeConnection();
  }

  //Modifica un solo ingrediente de una de las lista de ingredientes
  static Future<void> modifyIngredientInList(String id, int indexPrimaryList,
      int indexSecondaryList, String newIngredient) async {
    String listCon = 'listOfIngredients.' +
        indexPrimaryList.toString() +
        '.' +
        indexSecondaryList.toString();
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(
        where.id(ObjectId.parse(id)), modify.set(listCon, newIngredient));
    await Mongodb.closeConnection();
  }

  //Elimina un solo ingrediente de una lista de recetas
  static Future<void> deleteIngredientInList(
      String id, int indexPrimaryList, String removeIngredient) async {
    String listCon = 'listOfIngredients.' + indexPrimaryList.toString();
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(
        where.id(ObjectId.parse(id)), modify.pull(listCon, removeIngredient));
    await Mongodb.closeConnection();
  }

  // ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  //Aniade una nueva receta a la lista de recetas favoritas
  // ID USUARIO = "
  // 673516bd55397c8475000000
  // "
  static Future<void> addFavoriteRecipe(String id, Recipe newRecipe) async {
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)),
        modify.push('listFavoriteRecipes', newRecipe.toJson()));
    await Mongodb.closeConnection();
  }

  //Elimina una receta de la lista de favortitas
  static Future<void> deleteFavoriteRecipe(
      String id, Recipe deleteRecipe) async {
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)),
        modify.pull('listFavoriteRecipes', deleteRecipe.toJson()));
    await Mongodb.closeConnection();
  }

  //Modifica algun elemento de una receta favorita
  // id = usuario , primaryIndex = indice receta , Space = {nombre, ingrediente ,campo etc}, Newdata= remplazco, secondaryIndex = indice del ingrediente/paso (start=0)
  static Future<void> modifyElementOfFavoriteList(
      String id, int primaryIndex, String space, String newData,
      [int? secondaryIndex]) async {
    await Mongodb.ConnectWhitMongo();
    if (secondaryIndex != null) {
      String listCon = 'listFavoriteRecipes.' +
          primaryIndex.toString() +
          "." +
          space +
          "." +
          secondaryIndex.toString();
      await Mongodb.userCollection.updateOne(
          where.id(ObjectId.parse(id)), modify.set(listCon, newData));
    } else {
      String listCon =
          'listFavoriteRecipes.' + primaryIndex.toString() + "." + space;
      await Mongodb.userCollection.updateOne(
          where.id(ObjectId.parse(id)), modify.set(listCon, newData));
    }
    await Mongodb.closeConnection();
  }

  //Elimina un elemento de los ingredientes o los pasos
  static Future<void> deleteOfListIngredients_Steps(
      String id, int primaryIndex, String space, String itemToDelete) async {
    String listCon = 'listFavoriteRecipes.' +
        primaryIndex.toString() +
        "." +
        space.toString();
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(
        where.id(ObjectId.parse(id)), modify.pull(listCon, itemToDelete));
    await Mongodb.closeConnection();
  }

  static Future<void> addOfIngredients_Steps(
      String id, int primaryIndex, String space, String newItem) async {
    String listCon = 'listFavoriteRecipes.$primaryIndex.$space';
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection
        .updateOne(where.id(ObjectId.parse(id)), modify.push(listCon, newItem));
    await Mongodb.closeConnection();
  }

  static Future<String> registerUser(String userName, String userEmail,
      String password, String confirmPassword) async {
    // Verificar si las contraseñas coinciden
    if (password != confirmPassword) {
      return 'Las contraseñas no coinciden';
    }

    // Verificar si el nombre de usuario ya está en uso
    bool isUsernameTaken = await Mongodb.checkUsername(userName);
    if (isUsernameTaken) {
      return "El nombre de usuario ya está en uso.";
    }

    // Verificar si el correo electrónico ya está registrado
    bool isEmailTaken = await Mongodb.checkEmail(userEmail);
    if (isEmailTaken) {
      return "El correo electrónico ya está registrado.";
    }

    // Encriptamos la contraseña antes de guardarla en la base de datos
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    // Creamos un nuevo objeto User
    User newUser = User(
      userName: userName,
      userEmail: userEmail,
      password: hashedPassword,
      profileImg:
          "", // Podrías agregar una imagen de perfil más tarde si lo deseas
      favoriteIngredients: [],
      listOfIngredients: [],
      listFavoriteRecipes: [],
    );

    try {
      // Conectamos a la base de datos
      await Mongodb.ConnectWhitMongo();

      // Guardamos el nuevo usuario en la base de datos
      await Mongodb.insertUser(newUser.toJson());

      // Cerramos la conexión a la base de datos
      await Mongodb.closeConnection();

      // Devolvemos un mensaje de exito
      return 'Usuario registrado exitosamente';
    } catch (e) {
      // En caso de error, devolvemos un mensaje con el error
      return 'Error al registrar usuario: $e';
    }
  }

Future<bool> loginUser(String userName, String password) async {
    try {
      await Mongodb.ConnectWhitMongo();
      final userCollection = await Mongodb.userCollection;

      // Buscamos al usuario por nombre de usuario
      var userResult =
          await userCollection.findOne(where.eq('userName', userName));

      if (userResult == null) {
        await Mongodb.closeConnection();
        print("login: no se encontro");
        return false;
      }

      // Comparamos las contraseñas
      String storedPassword = userResult['password'];
      bool passwordMatches = BCrypt.checkpw(password, storedPassword);

      if (passwordMatches) {
        userId = userResult['_id'].toString();  // Aquí actualizas el userId
        print("user id despues de login: $userId");
        await Mongodb.closeConnection();
        return true;
      }
    } catch (e) {
      await Mongodb.closeConnection();
      return false;
    }
    return false;
  }

  Future<String> checkIfUserExists(String name, String email) async {
    // Aquí llamas a tu servicio o API que verifica si el nombre de usuario o el correo ya están en uso
    bool usernameExists = await Mongodb.checkUsername(name);
    bool emailExists = await Mongodb.checkEmail(email);

    print("Repetido user: $usernameExists");
    print("Repetido email: $emailExists");

    if (usernameExists || emailExists) {
      return "El nombre de usuario ya está en uso.";
    } else if (emailExists) {
      return "El correo electrónico ya está registrado.";
    } else {
      return "Disponible";
    }
  }


  //Agrega una nueva lista a la lista de recetas
Future<void> addNewListOfIngredients(String userId,List<String> newList) async {
  // Obtener el userId directamente desde el servicio

  print("receta agregar id: ${getId()}");

  // Verificar si el userId es válido (debe tener 24 caracteres)
  if (userId.length != 24) {
    print("ID inválido: El ID debe tener 24 caracteres.");
    return; // Salir o manejar el error
  }

  // Conexión con la base de datos
  await Mongodb.ConnectWhitMongo();
  final userCollection = await Mongodb.userCollection;

  try {
    // Actualizar los ingredientes en la colección del usuario
    var result = await userCollection.update(
      where.id(ObjectId.parse(userId)), // Convertir el userId a ObjectId
      modify.set("listOfIngredients", newList), // Establecer la lista de ingredientes
    );

    print("Resultado de la actualización: $result");
  } catch (e) {
    print("Error al actualizar la receta: $e");
  } finally {
    // Cerrar la conexión a la base de datos
    await Mongodb.closeConnection();
  }
}
}
