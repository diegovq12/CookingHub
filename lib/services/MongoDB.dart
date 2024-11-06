import 'CONST-DB.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Mongodb {
  //VARIABLE QUE REPRESENTA LA COLECCION A LA QUE SE QUIERE CONECTAR
  static late DbCollection actualCollection;
  static Db? db;

  //SE CONECTA A LA BASE DE DATOS
  static Future<void> connecWhitMongo() async {
    db = await Db.create(CONNECTIONDB); //AQUI SE AGREGA LA VARIABLE CREADA EN  CONST_DB
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
  }

  static Future<void> insertRecipe(newRecipe) async {
    actualCollection = db!.collection(RECIPECOLLECTION);
    await actualCollection.insertOne(newRecipe);
  }

  static DbCollection get recipeCollection {
    actualCollection = db!.collection(RECIPECOLLECTION);
    if (actualCollection == Null) {
      throw Exception('Database is not connected');
    }
    return actualCollection;
  }

  //SE INSERA EL REGISTRO A LA COLECCION
  static Future<void> insertUser(newUser) async {
    actualCollection =
        db!.collection(USERCOLLECTION); //SE INGRESA LA COLECCION DESEADA
    await actualCollection.insertOne(newUser);
  }

  static DbCollection get userCollection {
    actualCollection = db!.collection(USERCOLLECTION);
    if (actualCollection == Null) {
      throw Exception('Database is not connected');
    }
    return actualCollection;
  }
}
