import 'package:cooking_hub/domain/entities/message.dart';
import 'package:cooking_hub/services/openai_services.dart';
import 'package:flutter/material.dart';

const maxLength = 50;

class ChatProvider extends ChangeNotifier{

  final chatScrollController = ScrollController();

  List<Message> messageList = [
  ];

  Future<void> sendMessage(String text) async{
    if(text.isEmpty){
      return;
    }

    if(text.length > maxLength){
   
      messageList.add(Message(text: text, fromWho: FromWho.me));
       notifyListeners();
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
    final responseText = await OpenAIService().sendTextCompletionRequest(newMessage.text);

    final gptMessage = Message(text: responseText, fromWho: FromWho.gpt);
    messageList.add(gptMessage);

    notifyListeners();
    moveScrollToBottom();    
  }


  Future<void> moveScrollToBottom()async{
    await Future.delayed(const Duration(milliseconds: 300));
    
    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent
    , duration: const Duration(milliseconds: 300)
    , curve: Curves.easeOut);
  }


}

