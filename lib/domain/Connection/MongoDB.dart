import 'package:cooking_hub/domain/Connection/CONST-DB.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:cooking_hub/domain/entities/user_model.dart';
import 'Temp.dart';

class Mongodb {
  //VARIABLE QUE REPRESENTA LA COLECCION A LA QUE SE QUIERE CONECTAR
  static late DbCollection LaColeccion;
  static Db? db;

  //SE CONECTA A LA BASE DE DATOS
  static Future<void> ConnecWhitMongo() async {
    db = await Db.create(CONNECTIONDB);//AQUI SE AGREGA LA VARIABLE CREADA EN  CONST_DB
    try {
      await db!.open();
      print("Conexion exitosa");
    } catch (e) {
      print("Error al conectar: $e");
    }
  }

  //SE INSERA EL REGISTRO A LA COLECCION
  static Future<void> insert(newUser) async {
    LaColeccion = db!.collection(COLLECTIONINGREDIENTS);//SE INGRESA LA COLECCION DESEADA
    await LaColeccion.insertOne(newUser);
  }

  //CIERRA LA CONEXION CON LA BASE DE DATOS
  static Future<void> closeConnection() async {
    db!.close();
  }
}
