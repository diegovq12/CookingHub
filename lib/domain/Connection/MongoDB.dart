import 'package:cooking_hub/domain/Connection/CONST-DB.dart';
import 'package:cooking_hub/domain/Connection/Temp.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'Temp.dart';
class Mongodb {

  static late DbCollection LaColeccion;

  static Future<void>ConnecWhitMongo(LaCosa cosa) async{
    final db = await Db.create(CONNECTIONDB);
    try{
      
      await db.open();
      print("Conexion exitosa");
      LaColeccion = db.collection("sessions");
      insert(cosa);

    }catch(e){
      print("Error al conectar: $e");
    }finally{
      await db.close();
    }
  }

  static Future<void> insert(LaCosa cosa) async{
    await LaColeccion.insertOne(cosa.toMap());
  }
}