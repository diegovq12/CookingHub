import 'package:mongo_dart/mongo_dart.dart';

class DatabaseServices {
  Db? _db;
  DbCollection? _recipesCollection;

  Future<void> connect() async {
    _db = await Db.create(
        'mongodb+srv://CookingHub:XGVbU56Z6siQDGI8@antoniocluster.7byrg.mongodb.net/CookingHub?retryWrites=true&w=majority');
    await _db!.open();
    _recipesCollection = _db!.collection('recipes');
  }

  DbCollection get recipesCollection {
    if (_recipesCollection == null) {
      throw Exception('Database is not connected.');
    }
    return _recipesCollection!;
  }

  Future<void> insertRecipe(Map<String, dynamic> recipe) async {
    var existingRecipe =
        await _recipesCollection!.findOne({'name': recipe['name']});
    if (existingRecipe != null) {
      return;
    }
    await _recipesCollection!.insert(recipe);
  }

  

  Future<void> close() async {
    await _db!.close();
  }
}
