import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cooking_hub/presentation/screens/listaCompras.dart';
import 'package:cooking_hub/presentation/screens/recetas.dart';
import 'package:cooking_hub/presentation/screens/realTimeCamera.dart';
// import 'package:cooking_hub/screens/recetasDetectadas.dart';
// import 'package:flutter/services.dart';
import 'dart:io';


class chatBot extends StatefulWidget{
  const chatBot({super.key});

  @override
  State<StatefulWidget> createState() => _chatBot();
}

class _chatBot extends State<chatBot>{
  
  // ------------ Camara -------------- //
  
  File? image_captured;

  Future<void> _openCamera() async{
    final picker = ImagePicker();
    final imagePicker = await picker.pickImage(source: ImageSource.camera);

    if(imagePicker != null){
      setState(() {
        image_captured = File(imagePicker.path);
      });
    }

  }

  // -------- Galeria -------- // 
  Future<void> _openGallery() async{
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    
    if(imageFile != null){
      // Usamos setState para actualizar el ui de la aplicacion, es decir actualizar o refrescar la imagen
      setState(() {
        image_captured = File(imageFile.path);
      });
    }
  }

  // -------- Texto -------- //

  // ----- Control de entrada de texto ---- //
  final TextEditingController _controller = TextEditingController();

  String mensaje = '';

  void promp(String texto){
    setState(() {
      mensaje = texto;
      // Limpiamos el cuadro de texto
      _controller.clear();
    });
  }



  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
          body: Stack(
            children: [
              // Fondo
              backgroundImage(),
              
              // Cuadro de fondo + Entrada de texto
              Container(
                decoration: chatFondoDecoration(),
                
                width: double.infinity,
                
                margin: EdgeInsets.only(
                  top: screenHeight*0.01,
                  left: screenWidth*0.01,
                  right: screenWidth*0.01,
                  bottom: screenHeight*0.06
                ),
                
                // El cuadro de entrada de texto
                child: inputText()
              ),
              
              // Contenedor del chat --------
              chatContainer(screenHeight: screenHeight, screenWidth: screenWidth, mensaje: mensaje, image_captured: image_captured),
              
              // Iconos de adjuntar y camara
              chatButtons(context),

              // Titulo
              titleCookBot(screenHeight, screenWidth),

              // ------- Esta sera la funcion para la ventana emergente de confirmacion ----- //
              // saveListWindow(screenWidth, screenHeight),

              // listNameConfirm(screenWidth, screenHeight),

              //-- HotBar
              HotBar()
              
            ],
          ),
        ),
      )
    );
  }

  Stack listNameConfirm(double screenWidth, double screenHeight) {
    return Stack(
            children: [
              ModalBarrier(
                color: Colors.black.withOpacity(0.5),
                dismissible: true,
              ),
              Center(
                child: Container(
                  decoration: chatFondoDecoration(),
                  margin: EdgeInsets.all(10),
                  width: screenWidth*0.8,
                  height: screenHeight*0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Nombre : ",style: windowStyle(),textAlign: TextAlign.center,),
                      SizedBox(height: screenHeight*0.02,),
                      
                      Container(
                        height: screenHeight*0.05,
                        margin: EdgeInsets.only(
                          left: screenWidth*0.02,
                          right: screenWidth*0.02,
                        ),
                        child: Expanded(
                          child: 
                            TextField(
                              controller: _controller,
                              decoration: inputBox(),
                              // -- Cuando presione enter
                              onSubmitted: promp,
                            ),
                        ),
                      ),
                      SizedBox(height: screenHeight*0.02,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: (){},
                            child: Container(
                              decoration: buttonDecoration(),
                              padding: EdgeInsets.all(screenHeight*0.02),
                              child: Text("Confirmar", style: normalStyle(),),
                            ),
                          ),
                          InkWell(
                            onTap: (){},
                            child: Container(
                              decoration: buttonDecoration(),
                              padding: EdgeInsets.all(screenHeight*0.02),
                              child: Text("Cancelar", style: normalStyle(),),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
  }

  Stack saveListWindow(double screenWidth, double screenHeight) {
    return Stack(
              children: [
                ModalBarrier(
                  color: Colors.black.withOpacity(0.5),
                  dismissible: true,
                ),
                Center(
                  child: Container(
                    decoration: chatFondoDecoration(),
                    margin: EdgeInsets.all(10),
                    width: screenWidth*0.8,
                    height: screenHeight*0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Quieres guardar esta lista de ingredientes?",style: windowStyle(),textAlign: TextAlign.center,),
                        SizedBox(height: screenHeight*0.05,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: (){},
                              child: Container(
                                decoration: buttonDecoration(),
                                padding: EdgeInsets.all(screenHeight*0.02),
                                child: Text("Si", style: normalStyle(),),
                              ),
                            ),
                            InkWell(
                              onTap: (){},
                              child: Container(
                                decoration: buttonDecoration(),
                                padding: EdgeInsets.all(screenHeight*0.02),
                                child: Text("No", style: normalStyle(),),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
  }

  TextStyle normalStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 20);

  BoxDecoration buttonDecoration() {
    return BoxDecoration(
            color: Color(0xFFFF8330),
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

  Align titleCookBot(double screenHeight, double screenWidth) {
    return Align(
              alignment: Alignment.topCenter,
              child: Container(
                  decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 168, 50, 1),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(120, 0, 0, 0),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, 3)
                    )
                  ]
                ),
                margin:  EdgeInsets.only(
                  top: screenHeight * 0.03,
                  left: screenWidth*0.03,
                  right: screenWidth*0.03,
                ),
                height: screenHeight*0.1,

                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("CookingBot",style: TextStyle(color: Colors.white,fontSize: 64,
                  fontFamily: 'Poppins',fontWeight: FontWeight.bold),),],
                ),
              ),
            );
  }

  TextStyle titleStyle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 36, fontWeight: FontWeight.bold);
  
  TextStyle windowStyle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 30,);

  Align chatButtons(BuildContext context) {
    return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 75,
                  right: 10
                ),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    // Adjuntar
                    IconButton(onPressed:(){
                      _openGallery();
                    }, iconSize: 
                    35,
                    icon: Image.asset("assets/chatIcons/adjuntar.png",width: 40,)),
                    // Abrir camara
                    IconButton(onPressed:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CamaraTiempoReal()));
                      }, 
                    iconSize: 35,
                    icon: Image.asset("assets/chatIcons/camera.png",width: 40,)),
                  ],
                ),
              ),
            );
  }

  Container inputText() {
    return Container(
                margin: const EdgeInsets.only(
                  bottom: 20,
                  left: 10,
                  right: 120,
                ),

                // -- Cuadro de texto
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  TextField(
                    controller: _controller,
                    decoration: inputBox(),
                    // -- Cuando presione enter
                    onSubmitted: promp,
                    ),
                  ],
                ),
              );
  }

  BoxDecoration chatFondoDecoration() {
    return const BoxDecoration(
                color: Color(0xFFE29732),
                borderRadius: BorderRadius.all(Radius.circular(16))
              );
  }

  InputDecoration inputBox() {
    return const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide.none      
                        )
                      );
  }
}

class chatContainer extends StatelessWidget {
  const chatContainer({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.mensaje,
    required this.image_captured,
  });

  final double screenHeight;
  final double screenWidth;
  final String mensaje;
  final File? image_captured;

  @override
  Widget build(BuildContext context) {
    return Container(
      // ------------- COMENTARIO -------------
      // Cuando implementen el codigo del chat aqui sera el contenedor donde estara
      
      width: double.maxFinite,
      
      margin:  EdgeInsets.only(
        top: screenHeight*0.14,
        left: screenWidth*0.03,
        right: screenWidth*0.03,
        bottom: 140
      ),
    
      child: Column(
        children: [
          Text("Aqui ira el chat, Mensaje actual $mensaje"),
    
          if(image_captured != null)
            Image.file(image_captured!, width: screenHeight*0.2,)
          
        ],
      ),
    );
  }
}

class backgroundImage extends StatelessWidget {
  const backgroundImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/Background.png"),
        fit: BoxFit.cover)
      ),
    );
  }
}

class HotBar extends StatelessWidget {
  const HotBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        
        decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 170, 50, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16)
          )
        ),
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: (){}, icon: Image.asset("assets/HotBar/Home.png",width: 30,)),
            IconButton(onPressed: (){}, icon: Image.asset("assets/HotBar/Games.png",width: 30,)),
            Positioned(
              child: IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const recetas()));
              },
              padding: const EdgeInsets.only(
                bottom: 2
              ), 
              icon: Image.asset("assets/HotBar/Gorrito.png",width: 50,)) ,
              ),
            IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const listaScreen()));}, 
            icon: Image.asset("assets/HotBar/Lista.png",width: 30,),),
            IconButton(onPressed: (){}, icon: Image.asset("assets/HotBar/Perfil.png",width: 30,)),
          ],
        ),
      ),
    );
  }
}
