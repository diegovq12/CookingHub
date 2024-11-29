import 'package:flutter/material.dart';
import 'package:cooking_hub/services/user_service.dart';

import 'package:cooking_hub/widgets/shared/background_image.dart';
import 'package:cooking_hub/widgets/shared/hot_bar.dart';


class Favoritos extends StatefulWidget{
  const Favoritos({super.key});

  @override
  State<StatefulWidget> createState() => _Favoritos();
}

class _Favoritos extends State<Favoritos>{

  // -------- Lista -------- //

  List<Map<String, int>> favIng = [
    {"Apple":1 },
    {"Prueba":100 },
    {"Ola":5 },
    
  ];

  void addToList (String name, int amount){
    setState(() {
      favIng.add({name:amount});
    });
  }

  // -------- Lista de Listas -------- //
  List<List<String>> listOfList = [];

  bool listBand = false;

  void showList (){
    setState(() {
      listBand = !listBand;
    });
  }

  // -------- contenida de la lista -------- //
  

  List<String> listIngredients = [];
  
  bool listIngBand = false;
  String listSelected = "";

  void showIngrd (){
    setState(() {
      listIngBand = !listIngBand;
    });
  }
  
  // -------- Texto de edicion -------- //
  // Control de entrada de texto
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerAmount = TextEditingController();

  void recibir() async{
    var user =await UserService().getUsers(UserService().getId());
    print("Usuario recuperado: $user");  // Verificar el resultado del usuario

    listOfList = user!.listOfIngredients;

    setState(() {
      
    });
  }

  int selected = 1;

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
                  recibir();
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
                        Text("Listas guardadas",style: titleStyle(),textAlign: TextAlign.center,),
                        SizedBox(height:screenHeight*0.02),
                        Expanded(
                          child: ListView.builder(
                            itemCount: listOfList.length,
                            itemBuilder: (context,current){
                              return ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: (){
                                          showList();
                                          // listSelected = name;
                                          showIngrd();
                                          selected = current;
                                        },
                                        child: Text("- ${listOfList[current][0]}", style: listsStyle(),)
                                        ),
                                    ),
                                    Container(
                                      decoration: deleteDecoration(),
                                      child: IconButton(
                                        onPressed: (){
                                          setState((){
                                            print("AdanBug $current");
                                            UserService().deleteOneListOfIngredients(UserService().getId(), listOfList[current]);
                                            listOfList.removeAt(current);
                                          });
                                        }, icon: Image.asset("assets/icons/delete.png",width: 20,))
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
                        Expanded(
                          child: ListView.builder(
                            itemCount: listOfList[selected].length,
                            itemBuilder: (context,current){
                              if(current == 0){
                                return ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text(listOfList[selected][current], style: titleStyle(),textAlign: TextAlign.center,)),
                                  ]
                                ));
                              }
                                return ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text("- ${listOfList[selected][current]}", style: normalStyle(),)),

                                    InkWell(
                                      onTap: (){
                                        editSection(context, screenHeight, screenWidth,current);
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
                                            Text(listOfList[selected][current][0],style: normalStyle(),),
                                            Image.asset("assets/icons/edit2.png",width: 20,)
                                          ],
                                        )
                                      ),
                                    ),
                                    
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
              ],
            );
  }

  // ------ Metodos para edicion ---------- //

  Future<dynamic> editSection(BuildContext context, double screenHeight, double screenWidth,int current) {
    _controllerName.text = listOfList[selected][current].substring(2);
    _controllerAmount.text = listOfList[selected][current][0];
    
    return showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      builder: (BuildContext context){
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // Ajuste del espacio con el teclado
            ),
          child: Container(
            alignment: Alignment.bottomLeft,

            height: screenHeight*0.4,
            
            decoration: backgroundDecoration(),
            
            child: Column(
              children: [
                editarIngredienteTitle(screenHeight, screenWidth),
                
                Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight*0.03,
                    left: screenWidth*0.09,
                    right: screenWidth*0.03,
                    bottom: screenHeight*0.05
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: screenWidth*0.2,
                        margin: EdgeInsets.only(
                          right: screenWidth*0.03
                        ),
                        child: Expanded(
                          child: TextField(
                            controller: _controllerAmount,
                            decoration: inputBoxAmount(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth*0.6,
                        
                        child: Expanded(
                          child: TextField(
                            controller: _controllerName,
                            decoration: inputBoxName(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // continueAndCancelButtons(screenHeight),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: screenHeight*0.03
                  ),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop(true);
                        _controllerAmount.clear();
                        _controllerName.clear();
                      },
                      child: Container(
                        padding:const EdgeInsets.all(10),
                        decoration: titleDecorationWithShadow(),
                        child: Text("Cancelar",style: buttonStyle(),),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                        String name = _controllerAmount.text.toString();
                        String amount = _controllerName.text.toString();

                        String ful = "$name $amount";

                        listOfList[selected][current] = ful;

                        UserService().modifyIngredientInList(UserService().getId(),selected,current,ful);
                          
                        });
                        Navigator.of(context).pop(true);
                      },
                      child: Container(
                        padding:const EdgeInsets.all(10),
                        decoration: titleDecorationWithShadow(),
                        child: Text("Continuar",style: buttonStyle(),),
                      ),
                    )
                  ],
                  ),
                ),
                
              ],
            ),
          ),
        ));
      });
  }

  InputDecoration inputBoxName() {
    return const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Ingrediente",
                        hintStyle: TextStyle(
                          color: Colors.grey
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide.none   
                        )
                      );
  }
  
  InputDecoration inputBoxAmount() {
    return const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Cantidad",
                        hintStyle: TextStyle(
                          color: Colors.grey
                        ),
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
                    itemCount: favIng.length,
                    itemBuilder: (context ,index){
                      String name = favIng[index].keys.first;
                      int amount = favIng[index][name]!;
                      
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
  