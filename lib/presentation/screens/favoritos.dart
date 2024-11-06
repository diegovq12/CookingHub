import 'package:flutter/material.dart';
import 'package:cooking_hub/presentation/screens/lista_compras.dart';
import 'package:cooking_hub/presentation/screens/recetas.dart';

class Favoritos extends StatefulWidget{
  const Favoritos({super.key});

  @override
  State<StatefulWidget> createState() => _Favoritos();
}

class _Favoritos extends State<Favoritos>{

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

  // -------- Lista de Listas -------- //

  List<Map<String, String>> lists = [
    {"Lista 1":"07/10/2024"},
    {"Lista 2":"07/10/2024"},
    {"Lista 3":"07/10/2024"},
    {"Lista 4":"07/10/2024"},
  ];
  
  bool listBand = false;

  void showList (){
    setState(() {
      listBand = !listBand;
    });
  }

  // -------- contenida de la lista -------- //
  
  List<Map<String, int>> listIngredients = [
    {"Milk":1},
    {"Orange":1},
    {"Apple":1},
  ];
  
  bool listIngBand = false;
  String listSelected = "";

  void showIngrd (){
    setState(() {
      listIngBand = !listIngBand;
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

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            BackgroundImage(),

            ingredientsList(screenHeight),

            titleContainer(screenHeight, screenWidth),

            Positioned(
              top: screenHeight*0.17,
              left: screenWidth*0.02,
              child: Container(
                decoration: buttonDecoration(),
                child: IconButton(onPressed: (){
                  showList();
                }, icon: Image.asset("assets/HotBar/Lista.png",width: screenWidth*0.05,))),
            ),

            const HotBar(),

            if(listBand)...[
              listOfLists(screenHeight)
            ],


            if(listIngBand)...[
              listOfIngredients(screenHeight, screenWidth)
            ]
          ],
        ),
      )
    );
  }

  // -------- Lista de ingredientes --------- //

  Stack listOfIngredients(double screenHeight, double screenWidth) {
    return Stack(
              children: [
                ModalBarrier(
                  color: Colors.black54,
                  dismissible: true,
                  // Cuando presione afuera del cuadro
                  onDismiss: showIngrd,
                ),
                Center(
                  child: Container(
                    decoration: containerDecoration(),
                    margin: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        SizedBox(height:screenHeight*0.02),
                        Text(listSelected ,style: titleStyle(),),
                        SizedBox(height:screenHeight*0.02),
                        Expanded(
                          child: ListView.builder(
                            itemCount: listIngredients.length+1,
                            itemBuilder: (context,current){
                              // Si es el ultimo
                              if(current == listIngredients.length){
                                return Padding(
                                  padding: EdgeInsets.only(left:screenWidth*0.02),
                                  child: InkWell(
                                    onTap: (){
                                      
                                    },
                                    child: Text("+Agregar",style: normalStyle(),)
                                    ),
                                );
                              }
                              else
                              {
                                String name = listIngredients[current].keys.first;
                                int amount = listIngredients[current][name]!;
                                  return ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("- $name", style: listsStyle(),),

                                      InkWell(
                                        onTap: (){
                                          editSection(context, screenHeight, screenWidth);
                                        },
                                        child: Container(
                                          decoration: deleteDecoration(),
                                          padding: EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("$amount",style: normalStyle(),),
                                              Image.asset("assets/icons/edit2.png",width: 20,)
                                            ],
                                          )
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
  }

  // ------ Metodos para edicion ---------- //

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

  BoxDecoration backgroundDecoration() {
    return const BoxDecoration(
                  color: Color.fromRGBO(255, 168, 50, 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                );
  }

  // --------- Lista de listas --------- //

  Stack listOfLists(double screenHeight) {
    return Stack(
              children: [
                ModalBarrier(
                  color: Colors.black54,
                  dismissible: true,
                  // Cuando presione afuera del cuadro
                  onDismiss: showList,
                ),
                Center(
                  child: Container(
                    decoration: containerDecoration(),
                    margin: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        SizedBox(height:screenHeight*0.02),
                        Text("Listas guardadas",style: titleStyle(),),
                        SizedBox(height:screenHeight*0.02),
                        Expanded(
                          child: ListView.builder(
                            itemCount: lists.length,
                            itemBuilder: (context,current){
                              String name = lists[current].keys.first;
                              String date = lists[current][name]!;
                              return ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        showList();
                                        listSelected = name;
                                        showIngrd();
                                      },
                                      child: Text("- $name - $date", style: listsStyle(),)
                                      ),
                                    Container(
                                      decoration: deleteDecoration(),
                                      child: IconButton(
                                        onPressed: (){}, icon: Image.asset("assets/icons/delete.png",width: 20,))
                                    )
                                  ],
                                ),
                              );
                            }
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
  }

  // ------ Estilos

  Container titleContainer(double screenHeight, double screenWidth) {
    return Container(
            decoration: containerDecoration(),

            margin: EdgeInsets.only(
              top: screenHeight*0.02,
              left: screenWidth*0.05,
              right: screenWidth*0.05,
            ),

            width: screenWidth*1,
            height: screenHeight*0.15,

            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Ingredientes Favoritos",style: titleStyle(),textAlign: TextAlign.center,),
              ],
            ),
          );
  }

  Container ingredientsList(double screenHeight) {
    return Container(
            decoration: containerDecoration(),

            margin: EdgeInsets.only(
              top: screenHeight*0.2

            ),

            child: Column(
              children: [
                SizedBox(
                  height: screenHeight*0.03,
                ),
                Expanded(
                  child: ListView.builder(
                    controller: ScrollController(),
                    itemCount: ingredients.length,
                    itemBuilder: (context ,index){
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
                          ],
                        ),
                      );
                    }
                  )
                )
              ],
            ),
          );
  }

  TextStyle normalStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 20);
  
  TextStyle listsStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 20,decoration: TextDecoration.underline,decorationColor: Colors.white);
  
  TextStyle buttonStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 20,fontWeight: FontWeight.bold);

  TextStyle titleStyle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 36, fontWeight: FontWeight.bold);

  BoxDecoration containerDecoration() {
    return BoxDecoration(
            color: Color(0xFFFFA832),
            borderRadius: BorderRadius.all(Radius.circular(16))
          );
  }
  
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
  
  BoxDecoration deleteDecoration() {
    return BoxDecoration(
            color: Color(0xFFFF8330),
            borderRadius: BorderRadius.all(Radius.circular(16)),
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const Recetas()));
              },
              padding: const EdgeInsets.only(
                bottom: 2
              ), 
              icon: Image.asset("assets/HotBar/Gorrito.png",width: 50,)) ,
              ),
            IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const ListaScreen()));}, 
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