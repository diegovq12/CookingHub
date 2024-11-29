import 'package:bcrypt/bcrypt.dart';

import 'MongoDB.dart';
import 'package:cooking_hub/domain/entities/user_model.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:cooking_hub/domain/entities/recipe_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;

  UserService._internal();

  String userId = "";

  String getId() {
    return userId;
  }

  void setId(String userId) {
    this.userId = userId;
  }

  String extractId(String objectIdText) {
    // Usa una expresión regular para extraer el ID
    final match =
        RegExp(r'ObjectId\("([a-fA-F0-9]{24})"\)').firstMatch(objectIdText);
    return match != null
        ? match.group(1)!
        : ""; // Devuelve el ID o una cadena vacía
  }

  Future<void> addUser(User newUser) async {
    await Mongodb.ConnectWhitMongo();
    await Mongodb.insertUser(newUser.toJson());
    await Mongodb.closeConnection();
  }

  Future<User?> getUsers(String id) async {
    // Extraer el userId utilizando la función extractId
    String extractedId = extractId(id);

    // Validar que el ID extraído tenga 24 caracteres
    if (extractedId.length != 24) {
      print("ID inválido: El ID debe tener 24 caracteres.");
      return null; // Salir si el ID no es válido
    }

    await Mongodb.ConnectWhitMongo();
    final userRecovery = await Mongodb.userCollection;

    try {
      // Buscar el usuario en la base de datos por ID
      var userResult =
          await userRecovery.findOne(where.id(ObjectId.parse(extractedId)));

      if (userResult != null) {
        return User.fromJson(
            userResult); // Convertir el resultado a un objeto User
      } else {
        print("Usuario no encontrado.");
      }
    } catch (e) {
      print("Error al buscar el usuario: $e");
    } finally {
      await Mongodb.closeConnection(); // Cerrar la conexión
    }

    return null;
  }

//Agrega un nuevo ingrediente a la lista de ingredientes fav
  Future<void> addNewIngredientsFavorites(
      String id, String newIngredient) async {
    // Obtener el userId directamente desde el servicio
    String userId = extractId(getId()); // Extraer solo el ID

    print("ID de usuario: $userId");

    // Verificar si el userId es válido (debe tener 24 caracteres)
    if (userId.length != 24) {
      print("ID inválido: El ID debe tener 24 caracteres.");
      return; // Salir o manejar el error
    }

    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)),
        modify.push('favoriteIngredients', newIngredient));
    await Mongodb.closeConnection();
  }

//Modifica un elemento de una de las listas de ingredientes
  Future<void> modifyListOfIngredients(
      String id, List<String> newList, int indexList) async {
    // Obtener el userId directamente desde el servicio
    String userId = extractId(getId()); // Extraer solo el ID

    print("ID de usuario: $userId");

    // Verificar si el userId es válido (debe tener 24 caracteres)
    if (userId.length != 24) {
      print("ID inválido: El ID debe tener 24 caracteres.");
      return; // Salir o manejar el error
    }

    String listCon = 'listOfIngredients.' + indexList.toString();
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection
        .updateOne(where.id(ObjectId.parse(id)), modify.set(listCon, newList));
    await Mongodb.closeConnection();
  }

//Elimina un de las lista de ingredientes
  Future<void> deleteOneListOfIngredients(
      String id, List<String> removeList) async {
    // Obtener el userId directamente desde el servicio
    String userId = extractId(getId()); // Extraer solo el ID

    print("ID de usuario: $userId");

    // Verificar si el userId es válido (debe tener 24 caracteres)
    if (userId.length != 24) {
      print("ID inválido: El ID debe tener 24 caracteres.");
      return; // Salir o manejar el error
    }

    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)),
        modify.pull('listOfIngredients', removeList));
    await Mongodb.closeConnection();
  }

//Modifica un solo ingrediente de una de las lista de ingredientes
  Future<void> modifyIngredientInList(String id, int indexPrimaryList,
      int indexSecondaryList, String newIngredient) async {
    // Obtener el userId directamente desde el servicio
    String userId = extractId(getId()); // Extraer solo el ID

    print("ID de usuario: $userId");

    // Verificar si el userId es válido (debe tener 24 caracteres)
    if (userId.length != 24) {
      print("ID inválido: El ID debe tener 24 caracteres.");
      return; // Salir o manejar el error
    }

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
  Future<void> deleteIngredientInList(
      String id, int indexPrimaryList, String removeIngredient) async {
    // Obtener el userId directamente desde el servicio
    String userId = extractId(getId()); // Extraer solo el ID

    print("ID de usuario: $userId");

    // Verificar si el userId es válido (debe tener 24 caracteres)
    if (userId.length != 24) {
      print("ID inválido: El ID debe tener 24 caracteres.");
      return; // Salir o manejar el error
    }

    String listCon = 'listOfIngredients.' + indexPrimaryList.toString();
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(
        where.id(ObjectId.parse(id)), modify.pull(listCon, removeIngredient));
    await Mongodb.closeConnection();
  }

// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//Aniade una nueva receta a la lista de recetas favoritas
// ID USUARIO = "673516bd55397c8475000000"
  Future<void> addFavoriteRecipe(String id, Recipe newRecipe) async {
    // Obtener el userId directamente desde el servicio
    String userId = extractId(getId()); // Extraer solo el ID

    print("ID de usuario: $userId");

    // Verificar si el userId es válido (debe tener 24 caracteres)
    if (userId.length != 24) {
      print("ID inválido: El ID debe tener 24 caracteres.");
      return; // Salir o manejar el error
    }

    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)),
        modify.push('listFavoriteRecipes', newRecipe.toJson()));
    await Mongodb.closeConnection();
  }

//Elimina una receta de la lista de favortitas
  Future<void> deleteFavoriteRecipe(String id, Recipe deleteRecipe) async {
    // Obtener el userId directamente desde el servicio
    String userId = extractId(getId()); // Extraer solo el ID

    print("ID de usuario: $userId");

    // Verificar si el userId es válido (debe tener 24 caracteres)
    if (userId.length != 24) {
      print("ID inválido: El ID debe tener 24 caracteres.");
      return; // Salir o manejar el error
    }

    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(where.id(ObjectId.parse(id)),
        modify.pull('listFavoriteRecipes', deleteRecipe.toJson()));
    await Mongodb.closeConnection();
  }

//Modifica algun elemento de una receta favorita
// id = usuario , primaryIndex = indice receta , Space = {nombre, ingrediente ,campo etc}, Newdata= remplazco, secondaryIndex = indice del ingrediente/paso (start=0)
  Future<void> modifyElementOfFavoriteList(
      String id, int primaryIndex, String space, String newData,
      [int? secondaryIndex]) async {
    // Obtener el userId directamente desde el servicio
    String userId = extractId(getId()); // Extraer solo el ID

    print("ID de usuario: $userId");

    // Verificar si el userId es válido (debe tener 24 caracteres)
    if (userId.length != 24) {
      print("ID inválido: El ID debe tener 24 caracteres.");
      return; // Salir o manejar el error
    }

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
  Future<void> deleteOfListIngredients_Steps(
      String id, int primaryIndex, String space, String itemToDelete) async {
    // Obtener el userId directamente desde el servicio
    String userId = extractId(getId()); // Extraer solo el ID

    print("ID de usuario: $userId");

    // Verificar si el userId es válido (debe tener 24 caracteres)
    if (userId.length != 24) {
      print("ID inválido: El ID debe tener 24 caracteres.");
      return; // Salir o manejar el error
    }

    String listCon = 'listFavoriteRecipes.' +
        primaryIndex.toString() +
        "." +
        space.toString();
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection.updateOne(
        where.id(ObjectId.parse(id)), modify.pull(listCon, itemToDelete));
    await Mongodb.closeConnection();
  }

//Añade un nuevo ingrediente o paso
  Future<void> addOfIngredients_Steps(
      String id, int primaryIndex, String space, String newItem) async {
    // Obtener el userId directamente desde el servicio
    String userId = extractId(getId()); // Extraer solo el ID

    print("ID de usuario: $userId");

    // Verificar si el userId es válido (debe tener 24 caracteres)
    if (userId.length != 24) {
      print("ID inválido: El ID debe tener 24 caracteres.");
      return; // Salir o manejar el error
    }

    String listCon = 'listFavoriteRecipes.$primaryIndex.$space';
    await Mongodb.ConnectWhitMongo();
    await Mongodb.userCollection
        .updateOne(where.id(ObjectId.parse(id)), modify.push(listCon, newItem));
    await Mongodb.closeConnection();
  }

  Future<String> registerUser(String userName, String userEmail,
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
        String idUser = userResult['_id'].toString();
        setId(idUser); // Aquí actualizas el userId
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

Future<void> addNewListOfIngredients(String userId, List<String> newList) async {
  // Obtener el userId directamente desde el servicio
  String id = extractId(getId()); // Extraer solo el ID

  print("Receta agregar id: $id");
  print("Nueva lista de ingredientes: $newList");

  // Verificar si el userId es válido (debe tener 24 caracteres)
  if (id.length != 24) {
    print("ID inválido: El ID debe tener 24 caracteres.");
    return; // Salir o manejar el error
  }

  // Conexión con la base de datos
  await Mongodb.ConnectWhitMongo();
  final userCollection = await Mongodb.userCollection;

  try {
    // Obtener el documento actual del usuario
    var userDocument = await userCollection.findOne(where.id(ObjectId.parse(id)));

    if (userDocument == null) {
      print("Usuario no encontrado.");
      return;
    }

    // Obtener la lista actual de ingredientes
    dynamic currentListOfIngredients = userDocument["listOfIngredients"];

    // Si no existe la lista de ingredientes, inicialízala
    if (currentListOfIngredients == null) {
      print("Inicializando listOfIngredients...");
      currentListOfIngredients = [];
    } else if (currentListOfIngredients is! List<dynamic>) {
      print("Formato incorrecto de listOfIngredients. Inicializando...");
      currentListOfIngredients = [];
    }

    // Asegurarse de que todos los elementos de currentListOfIngredients sean List<String>
    List<List<String>> safeListOfIngredients = [];
    for (var ingredientList in currentListOfIngredients) {
      if (ingredientList is List) {
        safeListOfIngredients.add(List<String>.from(ingredientList));
      } else {
        print("Elemento en listOfIngredients tiene un formato incorrecto.");
        // Si encuentras un elemento con formato incorrecto, puedes agregarlo como una lista vacía o saltarlo
        safeListOfIngredients.add([]);
      }
    }

    // Agregar la nueva lista a la colección
    safeListOfIngredients.add(newList);

    // Actualizar la base de datos con la nueva lista
    var result = await userCollection.update(
      where.id(ObjectId.parse(id)),
      modify.set("listOfIngredients", safeListOfIngredients),
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
