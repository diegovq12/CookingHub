import 'package:cooking_hub/domain/entities/message.dart';
import 'package:cooking_hub/services/google_vision_services.dart';
import 'package:cooking_hub/services/openai_services.dart';
import 'package:flutter/material.dart';

const maxLength = 50;

// RecipeModel? recipeText;

class ChatProvider extends ChangeNotifier{

  final chatScrollController = ScrollController();

  List<Message> messageList = [
    Message(text: '¡Hola! Soy CookBot, tu asistente en la cocina. ¿Listo para sorprender a tu paladar? ¡Dime qué se te antoja y juntos cocinemos algo increíble!', fromWho: FromWho.gpt)

  ];

  Future<void> sendMessage(String text) async{
    if(text.isEmpty){
      return;
    }

    if(text.length > maxLength){
      messageList.add(Message(text: 'Please enter a message with less than $maxLength characters', fromWho: FromWho.gpt));
        notifyListeners();
        moveScrollToBottom(); 
      return;
    }


    final newMessage = Message(text: text, fromWho: FromWho.me);
    messageList.add(newMessage);
    notifyListeners();
    moveScrollToBottom();
    await Future.delayed(const Duration(milliseconds: 300));
    var responseText = await OpenAIService().sendTextCompletionRequest(newMessage.text);

  try {
    responseText = OpenAIService().naturalLanguageResponse(responseText);
    messageList.add(Message(text: responseText, fromWho: FromWho.gpt));

  } catch (e) {
    messageList.add(Message(text: 'No pude procesar la receta. Por favor, intenta de nuevo.', fromWho: FromWho.gpt));
  }
    notifyListeners();
    moveScrollToBottom();    
  }

  Future<void> sendIngredientsByMessage() async {
    try {

      final detectedIngredients = await GoogleVisionServices().detectIngredients();

      if (detectedIngredients == 'Error al capturar imagen') {
        messageList.add(
          Message(text: 'Error al capturar o procesar la imagen.', fromWho: FromWho.me),
        );
        notifyListeners();
        moveScrollToBottom();
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
      responseText = OpenAIService().naturalLanguageResponse(responseText);
      
      messageList.add(Message(text: responseText, fromWho: FromWho.gpt));
      notifyListeners();
      moveScrollToBottom();
    } catch (e) {

      messageList.add(
        Message(text: 'No pude procesar la receta o la imagen. Por favor, intenta de nuevo.', fromWho: FromWho.gpt),
      );
      notifyListeners();
      moveScrollToBottom();
    }
  }


  Future<void> moveScrollToBottom()async{
    await Future.delayed(const Duration(milliseconds: 300));
    
    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent
    , duration: const Duration(milliseconds: 300)
    , curve: Curves.easeOut);
  }


}

