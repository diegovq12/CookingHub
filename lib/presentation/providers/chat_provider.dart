import 'dart:convert';

import 'package:cooking_hub/domain/entities/message.dart';
import 'package:cooking_hub/services/google_vision_services.dart';
import 'package:cooking_hub/services/openai_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ChatProvider extends ChangeNotifier {
  final chatScrollController = ScrollController();

  List<Message> messageList = [
    Message(
        text:
            '¡Hola! Soy CookBot, tu asistente en la cocina. ¿Listo para sorprender a tu paladar? ¡Dime qué se te antoja y juntos cocinemos algo increíble!',
        fromWho: FromWho.gpt)
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

  var responseText = await OpenAIService().sendTextCompletionRequest(newMessage.text);

  try {
    final recipeData = jsonDecode(responseText);

    // Verifica que la respuesta contiene una receta con los campos necesarios
    if (recipeData.containsKey('nombre') &&
        recipeData.containsKey('region') &&
        recipeData.containsKey('ingredientes') &&
        recipeData.containsKey('pasos')) {
      
      responseText = OpenAIService().naturalLanguageResponse(responseText);
      messageList.add(Message(text: responseText, fromWho: FromWho.gpt));
    } else {
      //Si no viene en formato
      messageList.add(Message(
        text: 'Este asistente solo proporciona ayuda con temas de cocina.',
        fromWho: FromWho.gpt,
      ));
    }
  } catch (e) {

    messageList.add(Message(
      text: 'Este asistente solo proporciona ayuda con temas de cocina.',
      fromWho: FromWho.gpt,
    ));
  }
  notifyListeners();
  moveScrollToBottom();
}


Future<void> sendIngredientsByPhoto(ImageSource fuente) async {
  try {
    final detectedIngredients = await GoogleVisionServices().detectIngredients(fuente);

    //si no se captura o selecciona una imagen, cancelara la funcion
    if (detectedIngredients == 'Error al capturar imagen') {
      return;
    }

    final newMessage = Message(
      text: 'Receta con los siguientes ingredientes: $detectedIngredients',
      fromWho: FromWho.me,
    );
    messageList.add(newMessage);
    notifyListeners();
    moveScrollToBottom();

    var responseText = await OpenAIService().sendTextCompletionRequest(newMessage.text);
    print('prompt para foto: $responseText');
    responseText = OpenAIService().naturalLanguageResponse(responseText);
    messageList.add(Message(text: responseText, fromWho: FromWho.gpt));

    notifyListeners();
    moveScrollToBottom();
  } catch (e) {
    messageList.add(
      Message(
        text: 'No pude procesar la receta o la imagen. Por favor, intenta de nuevo.',
        fromWho: FromWho.gpt,
      ),
    );
    notifyListeners();
    moveScrollToBottom();
  }
}

  Future<void> moveScrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 300));

    chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }
}