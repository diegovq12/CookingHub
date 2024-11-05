import 'package:cooking_hub/domain/Connection/MongoDB.dart';
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
}
