import 'package:cooking_hub/domain/entities/message.dart';
import 'package:cooking_hub/presentation/providers/chat_provider.dart';
import 'package:cooking_hub/widgets/chat/gtp_message_bubble.dart';
import 'package:cooking_hub/widgets/chat/my_message_bubble.dart';
import 'package:cooking_hub/widgets/shared/background_image.dart';
import 'package:cooking_hub/widgets/shared/hot_bar.dart';
import 'package:cooking_hub/widgets/shared/message_field_box.dart';
import 'package:cooking_hub/widgets/shared/message_field_button.dart';
import 'package:cooking_hub/widgets/shared/title_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final chatProvider = context.watch<ChatProvider>();

    return SafeArea(      
      child: Stack(
        children: [
          // Fondo de pantalla

          const BackgroundImage(),

          Container(
            decoration: backgroundChatDecoration(),
            width: double.infinity,
            margin: EdgeInsets.only(
                top: screenHeight * 0.01,
                left: screenWidth * 0.01,
                right: screenWidth * 0.01,
                bottom: screenHeight * 0.06),
          ),
          
          Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(226, 151, 50, 1),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            width: double.infinity,
            margin:
                const EdgeInsets.only(top: 16, left: 5, right: 5, bottom: 60),
            child: Column(
              children: [
                // Contenedor de "CookBot" en la parte superior
                const TitleContainer(title: "CookBot",),

                const SizedBox(height: 10),

                // Aquí se agrega el ListView.builder
                Expanded(
                  child: ListView.builder(
                    controller: chatProvider.chatScrollController,
                    itemCount: chatProvider.messageList.length,
                    itemBuilder: (context, index) {
                      final message = chatProvider.messageList[index];
                      return (message.fromWho == FromWho.me)
                          ? MyMessageBubble(message: message)
                          : GtpMessageBubble(message: message);
                    },
                  ),
                ),

                // Botones de adjuntar y cámara y espacio para que el usuario escriba
                Container(
                  margin: const EdgeInsets.only(bottom: 10, right: 10),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      const MessageFieldButton(
                          icon: Icons.photo_size_select_actual_outlined),
                      const MessageFieldButton(icon: Icons.camera_alt_outlined),
                      Expanded(
                        child: MessageFieldBox(
                            onValue: (value) =>
                                chatProvider.sendMessage(value)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

            const HotBar()
          
        ],
      ),
    );
  }
}

BoxDecoration backgroundChatDecoration() {
  return const BoxDecoration(
      color: Color(0xFFE29732),
      borderRadius: BorderRadius.all(Radius.circular(16)));
}
