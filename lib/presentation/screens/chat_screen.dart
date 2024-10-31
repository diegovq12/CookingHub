import 'package:cooking_hub/domain/entities/message.dart';
import 'package:cooking_hub/presentation/providers/chat_provider.dart';
import 'package:cooking_hub/widgets/chat/gtp_message_bubble.dart';
import 'package:cooking_hub/widgets/chat/my_message_bubble.dart';
import 'package:cooking_hub/widgets/shared/message_field_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
        AppBar(
          title: const Text('CookBot'),
          centerTitle: true,
        ),
      body: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  


  @override
  Widget build(BuildContext context) {

    final chatProvider = context.watch<ChatProvider>(); 


    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: chatProvider.chatScrollController,
                itemCount: chatProvider.messageList.length
                ,itemBuilder: (context, index){
                  final message = chatProvider.messageList[index];
                  return (message.fromWho == FromWho.me)
                  ? MyMessageBubble(message: message)
                  : GtpMessageBubble(message: message);
                }
              ),
            ),
            
            MessageFieldBox(
              onValue: (value) => chatProvider.sendMessage(value),
            )
          
          ],
        ),
      ),
    );
  }
}