import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:image_picker/image_picker.dart';

class GoogleVisionServices {
  String apikey = dotenv.env['GOOGLE_CLOUD_VISION_API_KEY'] ??
      'Api de cloud vision no encontrada';

  Future<String> detectIngredients(ImageSource fuente) async {
    // Carga la imagen desde la camara
    final picker = ImagePicker();
    final image = await picker.pickImage(source: fuente);

    if (image == null) return 'Error al capturar imagen';

    // Convierte la imagen a formato base64
    final bytes = await File(image.path).readAsBytes();
    final base64Image = base64Encode(bytes);

    // Carga el archivo JSON con las credenciales de cuenta de servicio
    final jsonString = await rootBundle.loadString('credencialescloud.json');
    final serviceAccount = ServiceAccountCredentials.fromJson(jsonString);

    // Genera un cliente autenticado con el token
    final authClient = await clientViaServiceAccount(
      serviceAccount,
      ['https://www.googleapis.com/auth/cloud-platform'],
    );

    final url = 'https://vision.googleapis.com/v1/images:annotate';

    try {
      final response = await authClient.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'requests': [
            {
              'image': {'content': base64Image},
              'features': [
                {
                  'type': 'LABEL_DETECTION',
                  'maxResults': 50
                } // Ajustado para incluir mas etiquetas
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final labels = result['responses'][0]['labelAnnotations'] as List;

        // Aplicación de multiples filtros
        final filteredLabels = labels
            .where((label) =>
                label['score'] > 0.75) // Ajustado para incluir mas etiquetas
            .map((label) => label['description'])
            .where((description) => _isIngredient(
                description)) // Filtro por categorias de alimentos
            .toList();

        print('Labels $filteredLabels');
        return filteredLabels.isNotEmpty
            ? filteredLabels.join(', ')
            : 'No se detectaron ingredientes específicos';
      } else {
        return 'Error: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Error al procesar la imagen: $e';
    } finally {
      authClient.close();
    }
  }

  bool _isIngredient(String description) {
    // Lista de ingredientes organizada por categorias
    final keywords = [
      // **Proteinas animales**
      'chicken', 'beef', 'pork', 'turkey', 'lamb', 'bacon', 'ham', 'salami',
      'sausage',
      'pepperoni', 'tuna', 'salmon', 'shrimp', 'lobster', 'crab', 'mussel',
      'fish',
      'egg', 'duck', 'goose', 'venison', 'trout', 'cod', 'sardine', 'tilapia',
      'swordfish',

      // **Proteinas vegetales y alternativas**
      'tofu', 'tempeh', 'seitan', 'lentil', 'chickpea', 'black bean',
      'kidney bean', 'soybean',
      'edamame', 'peanut', 'almond', 'cashew', 'walnut', 'pecan', 'hazelnut',
      'pistachio',
      'sunflower seed', 'pumpkin seed', 'flax seed', 'chia seed', 'hemp seed',
      'quinoa',

      // **Lacteos y derivados**
      'milk', 'cream', 'yogurt', 'cheese', 'butter', 'cream cheese',
      'sour cream', 'whipped cream',
      'ice cream', 'parmesan', 'mozzarella', 'cheddar', 'feta', 'brie',
      'cottage cheese',
      'ricotta', 'gouda', 'blue cheese', 'goat cheese', 'mascarpone',
      'evaporated milk', 'condensed milk',
      'skim milk', 'soy milk', 'almond milk', 'oat milk', 'coconut milk',
      'whey', 'buttermilk',
      'milk powder', 'margarine', 'cheese curd',

      // **Verduras**
      'lettuce', 'spinach', 'kale', 'cabbage', 'carrot', 'celery', 'broccoli',
      'cauliflower',
      'tomato', 'onion', 'garlic', 'potato', 'radish', 'beet', 'zucchini',
      'cucumber', 'pea',
      'eggplant', 'squash', 'mushroom', 'asparagus', 'artichoke', 'avocado',
      'chard', 'leek',
      'brussels sprout', 'sweet potato', 'green bean', 'chili', 'bell pepper',
      'jalapeno', 'pumpkin',
      'parsnip', 'turnip', 'okra', 'chayote', 'watercress', 'bok choy',
      'arugula', 'rosemary',
      'basil', 'thyme', 'oregano', 'sage', 'parsley', 'cilantro', 'dill',
      'tarragon', 'bay leaf',
      'fennel', 'lemongrass', 'chili pepper', 'cabbage', 'coriander', 'cumin',

      // **Frutas**
      'apple', 'banana', 'orange', 'lemon', 'lime', 'grape', 'pineapple',
      'strawberry', 'blueberry',
      'raspberry', 'peach', 'mango', 'kiwi', 'cherry', 'pear', 'plum',
      'watermelon', 'melon',
      'coconut', 'papaya', 'pomegranate', 'apricot', 'fig', 'persimmon',
      'nectarine', 'guava',
      'lychee', 'dragon fruit', 'jackfruit', 'mango', 'tangerine', 'kumquat',
      'mandarin', 'persimmon',
      'starfruit', 'grapefruit', 'cantaloupe', 'date', 'soursop',
      'passionfruit',

      // **Granos, cereales y productos de panaderia**
      'rice', 'quinoa', 'oat', 'corn', 'wheat', 'barley', 'millet', 'buckwheat',
      'couscous', 'spaghetti',
      'macaroni', 'noodle', 'bread', 'tortilla', 'bagel', 'croissant',
      'ciabatta', 'sourdough', 'pita',
      'pancake', 'waffle', 'crumpet', 'pasta', 'noodle', 'muesli', 'cornmeal',
      'grits', 'polenta',
      'cake', 'pie', 'cookie', 'donut', 'biscuit', 'pastry', 'brioche',
      'english muffin', 'bagel',

      // **Especias y condimentos**
      'salt', 'pepper', 'cinnamon', 'nutmeg', 'ginger', 'paprika', 'turmeric',
      'cumin', 'oregano',
      'basil', 'thyme', 'rosemary', 'saffron', 'chili', 'clove', 'cardamom',
      'vanilla', 'bay leaf',
      'parsley', 'cilantro', 'oregano', 'mustard', 'mayonnaise', 'ketchup',
      'soy sauce', 'vinegar',
      'olive oil', 'canola oil', 'vegetable oil', 'sesame oil', 'coconut oil',
      'peanut oil', 'almond oil',
      'vinegar', 'hot sauce', 'sriracha', 'mustard', 'mayo', 'ketchup',
      'horseradish', 'chili flakes',
      'sriracha', 'tahini', 'hoisin sauce', 'barbecue sauce',
      'Worcestershire sauce', 'fish sauce',

      // **Dulces y edulcorantes**
      'sugar', 'honey', 'maple syrup', 'molasses', 'agave syrup', 'stevia',
      'xylitol', 'brown sugar',
      'corn syrup', 'golden syrup', 'chocolate', 'cocoa', 'marzipan', 'caramel',
      'molasses', 'fondant',
      'sweetened condensed milk', 'icing sugar', 'powdered sugar', 'cornstarch',
      'gelatin', 'agar',
      'pudding', 'marshmallow', 'jelly', 'fruit preserve', 'jam', 'marmalade',

      // **Bebidas**
      'coffee', 'tea', 'water', 'orange juice', 'lemonade', 'apple juice',
      'grape juice', 'tomato juice',
      'milkshake', 'smoothie', 'cocktail', 'beer', 'wine', 'whiskey', 'vodka',
      'rum', 'gin', 'brandy',
      'champagne', 'soda', 'carbonated drink', 'iced tea', 'energy drink',
      'sports drink',

      // **Otros ingredientes comunes**
      'baking soda', 'baking powder', 'yeast', 'cornstarch', 'tapioca starch',
      'agar-agar', 'xanthan gum',
      'gelatin', 'liquid smoke', 'tamarind', 'miso', 'mustard powder',
      'coconut water', 'buttermilk',
      'olive paste', 'fish sauce', 'vinegar', 'liquorice', 'tamarind paste',
      'nutella', 'vegetable broth',
      'chicken broth', 'beef broth', 'tomato paste', 'coconut cream',
      'chocolate chips', 'poppy seeds',
      'chia seeds', 'coconut flakes', 'carob', 'corn flour', 'rice flour',
      'almond flour', 'wheat germ',
      'milk powder', 'cream of tartar', 'sauerkraut', 'kimchi', 'pickles',
      'ginger paste', 'garlic paste',
      'lime juice', 'lemon zest', 'pomegranate molasses', 'tamarind paste',

      // **Comida rapida y snacks**
      'chips', 'fries', 'popcorn', 'pretzel', 'nachos', 'pizza', 'hamburger',
      'hot dog', 'sushi', 'wrap',
      'sandwich', 'baguette', 'taco', 'burrito', 'wrap', 'kebabs', 'noodles',
      'fried rice', 'paella',
      'quesadilla', 'spring rolls', 'churros', 'crackers', 'granola bar',
      'candy', 'ice cream bar'
    ];

    // Verifica si la descripcion contiene alguna de las palabras clave
    return keywords
        .any((keyword) => description.toLowerCase().contains(keyword));
  }
}
