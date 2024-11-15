import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:cooking_hub/presentation/screens/chat_screen.dart';
// import 'package:cooking_hub/presentation/screens/chatBot.dart';

class CamaraTiempoReal extends StatefulWidget {
  const CamaraTiempoReal({super.key});

  @override
  _CamaraTiempoReal createState() => _CamaraTiempoReal();
}

class _CamaraTiempoReal extends State<CamaraTiempoReal> {
  
  // -------- Lista -------- //

  List<Map<String, int>> ingredients = [
    {"Apple":1 },
    {"Orange":2},
    {"Sandia":5},
    {"Platano":5},
    {"Agua":4},
    {"Arroz":8},
    {"Peras":1},
    {"tortillas":10},
    {"Sal":7},
    {"amount":4},
    {"Toños":3},
    {"Software":7},
    {"Estrenomascloideo":9},
  ];

  void addToList (String name, int amount){
    setState(() {
      ingredients.add({name:amount});
    });
  }

  // Mostrar lista de ingredientes
  bool openList = false;

  void showList (){
    setState(() {
      openList = !openList;
    });
  }

  // -------- Camara -------- //
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // DEBUG : A veces da excepciones al correrlo, pero solo pasa cuando debugeas
  late Future<void> _initializeControllerFuture = _cameraController.initialize();

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _cameraController.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  // ------ Texto de edicion ---------- //
  // Control de entrada de texto
  final TextEditingController _controller = TextEditingController();

  // Almacena el chambio que envia, mas no bien actualiza el mapa solo guarda el texto
  String newIngredient = '';

  void saveChange(String texto){
    setState(() {
      newIngredient = texto;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_cameraController),
                
                // Capturar imagen
                takeAPictureButton(screenHeight, context),
                
                chatButton(screenHeight, context),
                
                showListButton(screenHeight),
                
                if(openList) ...[
                  // Barrera para que no interactue con el fondo
                  ModalBarrier(
                    color: Colors.black54,
                    dismissible: true,
                    // Cuando presione afuera del cuadro
                    onDismiss: showList,
                  ),
                  Center(
                    child: Container(
                      decoration: ingredientsContainerDecoration(),

                      child: SizedBox(
                        height: screenHeight*0.8,
                        width: screenWidth*0.8,
                        child: Column(
                          children: [
                            titleArticulos(screenHeight, screenWidth),
                            
                            Expanded(
                              child: ListView.builder(
                                itemCount: ingredients.length,
                                itemBuilder: (context,index){
                                  String name = ingredients[index].keys.first;
                                  int amount = ingredients[index][name]!;
                                  
                                  return ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        
                                        Text("• $name",style: normalStyle(),),
                                        
                                        // Editar
                                        editButton(context, screenHeight, screenWidth, amount)
                                        // ------ Boton de editar
                                      ],
                                    ),
                                  );
                                }
                              ),
                            ),
                          ],
                        ),
                      ),  
                    ),
                  )
                ]
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  InkWell editButton(BuildContext context, double screenHeight, double screenWidth, int amount) {
    return InkWell(
                                        onTap: (){
                                          // editIngredientsSection(context, screenHeight, screenWidth);
                                        },
                                        child: Container(
                                          decoration:const BoxDecoration(
                                            color: Color.fromRGBO(255, 131, 48, 1),
                                            borderRadius: BorderRadius.all(Radius.circular(16))
                                          ),
                                          width: screenWidth*0.15,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              // Text("$amount",style: normalStyle(),),
                                              Image.asset("assets/icons/delete.png",width: 20,)
                                            ],
                                          ),
                                        ),
                                      );
  }

  Future<dynamic> editIngredientsSection(BuildContext context, double screenHeight, double screenWidth) {
    return showModalBottomSheet(
                                            context: context, 
                                            builder: (BuildContext context){
                                              return FractionallySizedBox(
                                                alignment: Alignment.bottomCenter,
                                                child: Container(
                                                  alignment: Alignment.bottomLeft,
                                                  
                                                  decoration: backgroundDecoration(),
                                                  height: screenHeight*0.4,
                                                  
                                                  child: Column(
                                                    children: [
                                                      editIngredientsTitle(screenHeight, screenWidth),
                                                      
                                                      // Entrada de texto
                                                      editIngredientsInputText(screenHeight, screenWidth),

                                                      cancelContinueButtons(screenHeight),
                                                      
                                                      restoreButton(),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
  }

  InkWell restoreButton() {
    return InkWell(
                                                    onTap: () {
                                                    },
                                                    child: Container(
                                                      padding:const EdgeInsets.all(10),
                                                      decoration: titleDecorationWithShadow(),
                                                      child: Text("Restablecer",style: buttonStyle(),),
                                                    ),
                                                  );
  }

  Padding cancelContinueButtons(double screenHeight) {
    return Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: screenHeight*0.03
                                                      ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                          },
                                                          child: Container(
                                                            padding:const EdgeInsets.all(10),
                                                            decoration: titleDecorationWithShadow(),
                                                            child: Text("Cancelar",style: buttonStyle(),),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                          },
                                                          child: Container(
                                                            padding:const EdgeInsets.all(10),
                                                            decoration: titleDecorationWithShadow(),
                                                            child: Text("Continuar",style: buttonStyle(),),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
  }

  Padding editIngredientsInputText(double screenHeight, double screenWidth) {
    return Padding(
                                                    padding: EdgeInsets.only(
                                                      top: screenHeight*0.03,
                                                      left: screenWidth*0.03,
                                                      right: screenWidth*0.03,
                                                      bottom: screenHeight*0.05
                                                    ),
                                                    child: TextField(
                                                      controller: _controller,
                                                      decoration: inputBox(),
                                                      onSubmitted: saveChange,
                                                    ),
                                                  );
  }

  Padding editIngredientsTitle(double screenHeight, double screenWidth) {
    return Padding(
                                                    padding: EdgeInsets.only(
                                                        top: screenHeight*0.02,
                                                        left: screenWidth*0.1,
                                                        right: screenWidth*0.1,
                                                      ),
                                                    child: const Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text("Editar Ingrediente",
                                                        style: TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 26,fontWeight: FontWeight.w600),),
                                                    ),
                                                  );
  }

  Padding titleArticulos(double screenHeight, double screenWidth) {
    return Padding(
                            padding: EdgeInsets.only(
                              top: screenHeight*0.02,
                              left: screenWidth*0.1
                            ),
                            child: Text("Articulos detectados",style: titleStyle(),),
                          );
  }

  BoxDecoration ingredientsContainerDecoration() {
    return const BoxDecoration(
                      color: Color(0xFFFFA832),
                      borderRadius: BorderRadius.all(Radius.circular(16))
                    );
  }

  Positioned showListButton(double screenHeight) {
    return Positioned(
                bottom: screenHeight*0.02,
                left: 20,
                child: IconButton(
                  icon: Image.asset("assets/icons/canasta.png",width: 50,),
                  onPressed: () {
                    showList();
                  },
                  iconSize: 50,
                ),
              );
  }

  Positioned chatButton(double screenHeight, BuildContext context) {
    return Positioned(
                bottom: screenHeight*0.02,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.chat, color: Colors.white),
                  iconSize: 50,
                  onPressed: () {
                      dispose();
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen()));
                    }, 
                  ),
                );
  }

  Padding takeAPictureButton(double screenHeight, BuildContext context) {
    return Padding(
                padding: EdgeInsets.only(
                  bottom: screenHeight*0.02
                ),
                child: Align(
                  alignment:Alignment.bottomCenter,
                  child: IconButton(
                    icon: Icon(Icons.circle, color: Colors.white),
                    onPressed: () async {
                      try {
                        await _initializeControllerFuture;
                        final image = await _cameraController.takePicture();
                        // ---------- Aqui tendriamos que hacer una forma de que la foto sea enviada al chat bot, 
                        // ademas de resaltar la imagen y agregarla a la lista ----------
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                        
                      } catch (e) {
                        print(e);
                      }
                    },
                    iconSize: 50,
                  ),
                ),
              );
  }

  BoxDecoration backgroundDecoration() {
    return const BoxDecoration(
                  color: Color.fromRGBO(255, 168, 50, 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                );
  }

  TextStyle normalStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 20);
  
  TextStyle buttonStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 20,fontWeight: FontWeight.bold);

  TextStyle titleStyle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 36, fontWeight: FontWeight.bold);

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

  BoxDecoration titleDecoration() {
    return const BoxDecoration(
            color: Color.fromRGBO(255, 131, 48, 1),
            borderRadius: BorderRadius.all(Radius.circular(16))
          );
  }
  
  BoxDecoration titleDecorationWithShadow() {
    return const BoxDecoration(
            color: Color.fromRGBO(255, 131, 48, 1),
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(120, 0, 0, 0),
                spreadRadius: 0,
                blurRadius: 5,
                offset: Offset(0, 2)
              )
            ]
          );
  }
}
