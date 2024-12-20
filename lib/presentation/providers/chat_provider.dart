import 'dart:convert';

import 'package:cooking_hub/domain/entities/message.dart';
import 'package:cooking_hub/services/google_vision_services.dart';
import 'package:cooking_hub/services/openai_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';

class ChatProvider extends ChangeNotifier {
  final chatScrollController = ScrollController();

  List<Message> messageList = [
    Message(
        text:
            '¡Hola! Soy CookBot, tu asistente en la cocina. ¿Listo para sorprender a tu paladar? Puedes pedirme recetas de la siguiente forma : Receta de pizza. !Adelante!',
        fromWho: FromWho.gpt)
  ];

  List<String> recipeList = [
  // Lista inicial vacía
  ];
  
  List<String> stepsList = [
  // Lista inicial vacía
  ];
  List<String> recipeNamesList=[
  ];
  
  List<String> recipeRegionList=[
  ];

Future<void> sendMessage(String text) async {
  if (text.isEmpty) {
    return;
  }

  final newMessage = Message(text: text, fromWho: FromWho.me);
  messageList.add(newMessage);
  notifyListeners();
  moveScrollToBottom();
  await Future.delayed(const Duration(milliseconds: 300));

  var responseText =
      await OpenAIService().sendTextCompletionRequest(newMessage.text);

  print('Diebug respuesta gpt: $responseText');
  try {
    // Verificar que responseText esté en JSON
    if (isJson(responseText)) {
      final recipeData = jsonDecode(responseText);

      if (recipeData.containsKey('nombre') &&
          recipeData.containsKey('region') &&
          recipeData.containsKey('ingredientes') &&
          recipeData.containsKey('pasos')) {
        responseText = OpenAIService().naturalLanguageResponse(responseText);
        messageList.add(Message(text: responseText, fromWho: FromWho.gpt));

        // Extraer los ingredientes del JSON y agregarlos a recipeList y stepsList
        if (recipeData['ingredientes'] is List) {
          recipeList = List<String>.from(recipeData['ingredientes']);
          stepsList = List<String>.from(recipeData['pasos']);
          recipeRegionList.add(recipeData['region']);
            if (recipeData['nombre'] is String) {
            recipeNamesList.add(recipeData['nombre']);
            } else {
            print("Error: 'nombre' no es una cadena.");
            }
          print("Adabug ingredientes: $recipeList");
        } else {
          print("Error: 'ingredientes' no es una lista.");
        }
      } else {
        messageList.add(Message(
          text: 'Lo siento, solo te puedo ayudar con recetas.',
          fromWho: FromWho.gpt,
        ));
      }
    } else {
      messageList.add(Message(
        text: 'Lo siento, solo te puedo ayudar con recetas.',
        fromWho: FromWho.gpt,
      ));
      print('Diebug respuesta gpt: $responseText La respuesta no está en formato JSON');
    }
  } catch (e) {
    messageList.add(Message(
      text: 'Error en el prompt: $e.',
      fromWho: FromWho.gpt,
    ));
  }

  notifyListeners();
  moveScrollToBottom();
}

Future<void> sendIngredientsByPhoto(ImageSource fuente) async {
    try {
      final detectedIngredients =
          await GoogleVisionServices().detectIngredients(fuente);

      // Si no se captura o selecciona una imagen, se cancelará la función
      if (detectedIngredients == 'Error al capturar imagen') {
        return;
      }

      final newMessage = Message(
        text: 'Imagen enviada, esperando receta...',
        fromWho: FromWho.me,
      );
      messageList.add(newMessage);
      notifyListeners();
      moveScrollToBottom();

      var responseText = await OpenAIService().sendTextCompletionRequest('cocina con $detectedIngredients');
      print('prompt para foto: $responseText');

      // Verificación si la respuesta es JSON válido
      try {
        final parsedJson = jsonDecode(responseText);
        if (parsedJson is Map<String, dynamic>) {
          // Si es JSON válido, lo agregamos al mensaje
          var responseText2 =
              OpenAIService().naturalLanguageResponse(responseText);
          messageList.add(Message(text: responseText2, fromWho: FromWho.gpt));
        } else {
          // Si no es un JSON esperado, devolvemos un mensaje por defecto
          messageList.add(Message(
            text: 'Respuesta no estructurada como JSON: $responseText',
            fromWho: FromWho.gpt,
          ));
        }
      } catch (e) {
        // Si no es JSON válido, mostramos un mensaje de error adecuado
        print('Error al parsear la respuesta de OpenAI: $e');
        messageList.add(Message(
          text:
              'No pude entender la imagen proporcionada. Por favor, asegúrate de que la imagen sea clara y contenga ingredientes reconocibles.',
          fromWho: FromWho.gpt,
        ));
      }

      notifyListeners();
      moveScrollToBottom();
    } catch (e) {
      messageList.add(
        Message(
          text:
              'No pude procesar la receta o la imagen. Por favor, intenta de nuevo. + $e',
          fromWho: FromWho.gpt,
        ),
      );
      notifyListeners();
      moveScrollToBottom();
    }
  }

  Future<void> moveScrollToBottom() async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (chatScrollController.hasClients) {
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

// Verifica si el contenido es JSON
  bool isJson(String str) {
    try {
      jsonDecode(str);
    } catch (e) {
      return false;
    }
    return true;
  }
}
