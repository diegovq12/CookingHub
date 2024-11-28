import 'CONST-DB.dart';
import 'package:mongo_dart/mongo_dart.dart';

/*
  id1 = 672842c9368c80edf2000000
  id2= 673516bd55397c8475000000
*/

class Mongodb {
  //VARIABLE QUE REPRESENTA LA COLECCION A LA QUE SE QUIERE CONECTAR
  static late DbCollection ActualCollection;
  static Db? db;

  //SE CONECTA A LA BASE DE DATOS
  static Future<void> ConnectWhitMongo() async {
    db = await Db.create(
        CONNECTIONDB); //AQUI SE AGREGA LA VARIABLE CREADA EN  CONST_DB
    try {
      await db!.open();
      print("Conexion exitosa");
    } catch (e) {
      print("Error al conectar: $e");
    }
  }

  //CIERRA LA CONEXION CON LA BASE DE DATOS
  static Future<void> closeConnection() async {
    db!.close();
    print("Conexion cerrada");
  }

  static Future<void> insertRecipe(newRecipe) async {
    ActualCollection = db!.collection(RECIPECOLLECTION);
    var existRecipe =
        await ActualCollection.findOne({'name': newRecipe['name']});
    if (existRecipe != null) {
      return;
    }
    await ActualCollection.insertOne(newRecipe);
  }

  static DbCollection get recipeCollection {
    ActualCollection = db!.collection(RECIPECOLLECTION);
    if (ActualCollection == null) {
      throw Exception('Database is not connected');
    }
    return ActualCollection;
  }

  //SE INSERA EL REGISTRO A LA COLECCION
  static Future<void> insertUser(newUser) async {
    ActualCollection =
        db!.collection(USERCOLLECTION); //SE INGRESA LA COLECCION DESEADA
    await ActualCollection.insertOne(newUser);
  }

  static DbCollection get userCollection {
    ActualCollection = db!.collection(USERCOLLECTION);
    if (ActualCollection == Null) {
      throw Exception('Database is not connected');
    }
    return ActualCollection;
  }

static Future<bool> checkUsername(String username) async {
  ActualCollection = db!.collection(USERCOLLECTION);
  // Hacer búsqueda sin importar mayúsculas y minúsculas
  var existingUser = await ActualCollection.findOne({'userName': RegExp('^' + username + '\$', caseSensitive: false)});
  print("Buscando usuario: $username");
  print("Usuario encontrado: $existingUser");
  return existingUser != null; // Si existe, retorna true
}

static Future<bool> checkEmail(String email) async {
  ActualCollection = db!.collection(USERCOLLECTION);
  // Hacer búsqueda sin importar mayúsculas y minúsculas
  var existingEmail = await ActualCollection.findOne({'userEmail': RegExp('^' + email + '\$', caseSensitive: false)});
  print("Buscando email: $email");
  print("Email encontrado: $existingEmail");
  return existingEmail != null; // Si existe, retorna true
}
}
