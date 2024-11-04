import 'package:flutter/material.dart';
import 'package:cooking_hub/presentation/screens/listaCompras.dart';
import 'package:cooking_hub/presentation/screens/recetas.dart';

class ingredientes extends StatefulWidget{
  const ingredientes({super.key});

  @override
  State<StatefulWidget> createState() => _ingredientes();
}

class _ingredientes extends State<ingredientes>{
  
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

  // -------- Texto de edicion -------- //
  // Control de entrada de texto
  final TextEditingController _controller = TextEditingController();
  
  // Ingrediente al que quiere editar
  String newIngredient = '';

  // Almacena el chambio que envia, mas no bien actualiza el mapa solo guarda el texto
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

    return SafeArea(child: Scaffold(
      body: Stack(
        children: [
          // --- Fondo - imagen
          BackGroundImage(),
          
          // --- Fondo con la lista
          DraggableScrollableSheet(
          initialChildSize: 0.5, // Tamaño inicial del contenedor
          minChildSize: 0.5,     // Tamaño mínimo cuando está deslizado hacia abajo
          maxChildSize: 1,     // Tamaño máximo cuando está deslizado hacia arriba

          builder: (BuildContext context, ScrollController scrollController) {
            return Stack(
              clipBehavior: Clip.none, // Permite que el Positioned sobresalga
              children: [
                
                // Contenedor principal
                Container(
                  decoration: backgroundDecoration(),
                  
                  margin: EdgeInsets.only(
                    top: screenHeight * 0.1,
                  ),
                  
                  child: Column(
                    children: [
                      // Espacio entre para el titul de arepas
                      SizedBox(height: screenHeight*0.03),
                      
                      // Título ingredientes
                      ingredientesTitle(screenWidth, screenHeight),
                      
                      // Lista de ingredientes
                      ingredientsList(screenHeight, scrollController, screenWidth),
                      // Botones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          addToListButton(),
                          
                          allSetButton()
                        ],
                      ),
                    ],
                  ),
                ),

                // Positioned para el título
                recipeTitle(screenHeight, screenWidth),
              ],
            );
          },
        ),


          // ---- Hot Bar
          HotBar(),
        ],
      ),
    ));
  }

  Positioned recipeTitle(double screenHeight, double screenWidth) {
    return Positioned(
                top: screenHeight * 0.07, // Ajusta para sobresalir en la parte superior
                left: screenWidth * 0.1,
                right: screenWidth * 0.1,
                child: Container(
                  decoration: titleDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Arepas",
                        style: titleStyle(),
                      ),
                    ],
                  ),
                ),
              );
  }

  InkWell allSetButton() {
    return InkWell(
                          onTap: (){},
                          child: Container(
                            decoration: titleDecoration(),
                            padding: EdgeInsets.all(10),
                            child: Text("Todo listo",style: normalStyle(),),
                          ),
                        );
  }

  InkWell addToListButton() {
    return InkWell(
                          onTap: (){},
                          child: Container(
                            decoration: titleDecoration(),
                            padding: EdgeInsets.all(10),
                            child: Text("Agregar a la lista",style: normalStyle(),),
                          ),
                        );
  }

  SizedBox ingredientsList(double screenHeight, ScrollController scrollController, double screenWidth) {
    return SizedBox(
      height: screenHeight*0.6,
      child: Expanded(
        child: ListView.builder(
          controller: scrollController,
          itemCount: ingredients.length,
          itemBuilder: (context, index) {
            String name = ingredients[index].keys.first;
            int amount = ingredients[index][name]!;
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "• $amount $name",
                    style: normalStyle(),
                  ),
                  // ------ Boton de editar
                  IconButton(
                    onPressed: () {
                      editSection(context, screenHeight, screenWidth);
                    },
                    icon: Image.asset(
                      "assets/icons/edit.png",
                      width: screenHeight * 0.03,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> editSection(BuildContext context, double screenHeight, double screenWidth) {
    return showModalBottomSheet(
      context: context, 
      builder: (BuildContext context){
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          child: Container(
            alignment: Alignment.bottomLeft,

            height: screenHeight*0.4,
            
            decoration: backgroundDecoration(),
            
            child: Column(
              children: [
                editarIngredienteTitle(screenHeight, screenWidth),
                
                inputText(screenHeight, screenWidth),
                
                continueAndCancelButtons(screenHeight),
                
                resotreButton(),
                
              ],
            ),
          ),
        );
      });
  }

  InkWell resotreButton() {
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

  Padding continueAndCancelButtons(double screenHeight) {
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

  Padding inputText(double screenHeight, double screenWidth) {
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

  Padding editarIngredienteTitle(double screenHeight, double screenWidth) {
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

  Padding ingredientesTitle(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.03,
        top: screenHeight * 0.01,
      ),
      child: Row(
        children: [
          Text(
            "Ingredientes:",
            style: titleStyle(),
          ),
        ],
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

class BackGroundImage extends StatelessWidget {
  const BackGroundImage({
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
