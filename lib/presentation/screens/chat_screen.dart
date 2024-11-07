import 'package:cooking_hub/domain/entities/message.dart';
import 'package:cooking_hub/presentation/providers/chat_provider.dart';
import 'package:cooking_hub/presentation/screens/ingredientes.dart';
import 'package:cooking_hub/widgets/chat/gtp_message_bubble.dart';
import 'package:cooking_hub/widgets/chat/my_message_bubble.dart';
import 'package:cooking_hub/widgets/shared/background_image.dart';
import 'package:cooking_hub/widgets/shared/hot_bar.dart';
import 'package:cooking_hub/widgets/shared/message_field_button.dart';
import 'package:cooking_hub/widgets/shared/title_container.dart';
import 'package:cooking_hub/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _ChatView extends StatefulWidget {
  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final TextEditingController nameControl = TextEditingController();

  bool showSave = false;

  void mostrar() {
    setState(() {
      showSave = !showSave;  // Usamos setState para que la interfaz de usuario se actualice cuando cambie showSave
    });
  }

  List<String>listaGuardada = [""];


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final chatProvider = context.watch<ChatProvider>();

    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return Stack(
              children: [
                ModalBarrier(
                  color: Colors.black54,
                  dismissible: true,
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(20),
                    decoration: containerDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Quieres guardar la lista de ingredientes?",
                          textAlign: TextAlign.center, style: windowTextStyle(),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Botón "No"
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 30),
                                  decoration: buttonDecoration(),
                                  child: Text("No",style: normalStyle(),),
                                ),
                              ),
                            ),
                            // Botón "Sí"
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop(false); 
                                  mostrar();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 30),
                                  decoration: buttonDecoration(),
                                  child: Text("Sí",style: normalStyle(),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );

        // Si el usuario elige "Sí", salir
        return shouldExit ?? false;
      },

      child: SafeArea(
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
                bottom: screenHeight * 0.06,
              ),
            ),

            Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(226, 151, 50, 1),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              width: double.infinity,
              margin: const EdgeInsets.only(top: 16, left: 5, right: 5, bottom: 60),
              child: Column(
                children: [
                  // Contenedor de "CookBot" en la parte superior
                  const TitleContainer(title: "CookingBot"),
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
                            : InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> ingredientes()));
                              },
                              child: GtpMessageBubble(message: message));
                      },
                    ),
                  ),

                  // Botones de adjuntar y cámara y espacio para que el usuario escriba
                  MessageFieldContainer(
                    onValue: ((value) => chatProvider.sendMessage(value)),
                  ),
                ],
              ),
            ),

            const HotBar(),

            // Mostrar el campo de texto solo cuando showSave es true
            if (showSave)
              Stack(
                children: [
                  ModalBarrier(
                    color: Colors.black54,
                    dismissible: true,
                    // Cuando presione afuera del cuadro
                    onDismiss: mostrar,
                  )
                  ,
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: containerDecoration(),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Nombre:", style: titleStyle(),),
                          TextField(
                            controller: nameControl,
                            decoration: inputBoxDecoration(),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.of(context).pop(false);
                                },
                                child: Container(
                                  decoration: buttonDecoration(),
                                  padding: EdgeInsets.all(16),
                                  child: Text("Cancelar",style: normalStyle()),
                                ),
                              ),
                              InkWell(
                                onTap: () async{
                                  Navigator.of(context).pop(true);
                                  
                                  listaGuardada = chatProvider.recipeList;
                                  listaGuardada.insert(0,nameControl.text.toString());
                                  
                                  await UserService.addNewListOfIngredients("672842c9368c80edf2000000",listaGuardada);
                                },
                                child: Container(
                                  decoration: buttonDecoration(),
                                  padding: EdgeInsets.all(16),
                                  child: Text("Continuar",style: normalStyle(),),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
              ),
          ],
        ),
      ),
    );
  }

  TextStyle normalStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 20);
  
  TextStyle listsStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 20,decoration: TextDecoration.underline,decorationColor: Colors.white);
  
  TextStyle buttonStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 20,fontWeight: FontWeight.bold);

  TextStyle titleStyle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 36, fontWeight: FontWeight.bold);
  
  TextStyle windowTextStyle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 36);

  BoxDecoration buttonDecoration() {
    return BoxDecoration(
            color: Color(0xFFFF9300),
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(120, 0, 0, 0),
                spreadRadius: 0,
                blurRadius: 5,
                offset: Offset(0, 1)
              )
            ]
          );
  }

  BoxDecoration containerDecoration() {
    return BoxDecoration(
            color: Color(0xFFFFA832),
            borderRadius: BorderRadius.all(Radius.circular(16))
          );
  }

  InputDecoration inputBoxDecoration() {
    return const InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: "Nombre",
      hintStyle: TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide.none,
      ),
    );
  }
}

BoxDecoration backgroundChatDecoration() {
  return const BoxDecoration(
    color: Color(0xFFE29732),
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );
}
