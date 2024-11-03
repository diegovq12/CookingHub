import 'package:mongo_dart/mongo_dart.dart';

class LaCosa{
  final ObjectId id;
  final String user_id;
  final String jwt; 

  const LaCosa({required this.id,required this.jwt, required this.user_id});

  Map<String, dynamic> toMap(){
    return{
      '_id':id,
      'user_id':user_id, 
      'jwt':jwt,
    };
  }

}