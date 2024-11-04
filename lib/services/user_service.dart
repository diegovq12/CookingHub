import 'package:cooking_hub/domain/Connection/MongoDB.dart';
import 'package:cooking_hub/domain/entities/user_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

class UserService {
  static Future<void> addUser(User newUser) async {
    await Mongodb.ConnecWhitMongo();
    await Mongodb.insert(newUser.toJson());
    await Mongodb.closeConnection();
  }
}
