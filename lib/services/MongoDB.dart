import 'CONST-DB.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Mongodb {
  //VARIABLE QUE REPRESENTA LA COLECCION A LA QUE SE QUIERE CONECTAR
  static late DbCollection ActualCollection;
  static Db? db;

  //SE CONECTA A LA BASE DE DATOS
static Future<void> ConnecWhitMongo() async {
  db ??= await Db.create(CONNECTIONDB);
  if (db!.state != State.open) {
    try {
      await db!.open();
      print("Conexión exitosa");
    } catch (e) {
      print("Error al conectar: $e");
      rethrow; // Volver a lanzar la excepción para que se gestione correctamente.
    }
  } else {
    print("La base de datos ya está abierta");
  }
}

  

  //CIERRA LA CONEXION CON LA BASE DE DATOS
  static Future<void> closeConnection() async {
    db!.close();
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
}
