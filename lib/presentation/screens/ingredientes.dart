import 'package:cooking_hub/presentation/screens/tutorial.dart';
import 'package:cooking_hub/widgets/shared/background_image.dart';
import 'package:cooking_hub/widgets/styles/containerStyle.dart';
import 'package:cooking_hub/widgets/styles/inputStyle.dart';
import 'package:cooking_hub/widgets/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:cooking_hub/widgets/shared/hot_bar.dart';
import 'package:cooking_hub/presentation/providers/chat_provider.dart';
import 'package:provider/provider.dart';


class ingredientes extends StatefulWidget {
  const ingredientes({super.key});

  @override
  State<StatefulWidget> createState() => _ingredientes();
}

class _ingredientes extends State<ingredientes> {
  // -------- Lista -------- //
  List<String> ing = [];
  List<String> steps = [];
  String name = "";

  // -------- Texto de edicion -------- //
  // Control de entrada de texto
  final TextEditingController nameControl = TextEditingController();
  final TextEditingController amountControl = TextEditingController();

  void limpiar() {
    setState(() {
      nameControl.clear();
      amountControl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    // Almaecnar la receta
    ing = chatProvider.recipeList;
    steps = chatProvider.stepsList;
    name = chatProvider.recipeNamesList.last;

    // Agregar 1 a los ingredientes que no tengan cantidad
    for (int i = 1; i < ing.length; i++) {
      if (!RegExp(r'^[0-9]').hasMatch(ing[i][0])) {
        ing[i] = "1 ${ing[i]}";
      }
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),

          // --- Fondo con la lista
          DraggableScrollableSheet(
            initialChildSize: 0.5, // Tamaño inicial del contenedor
            minChildSize: 0.5, // Tamaño mínimo cuando está deslizado hacia abajo
            maxChildSize: 1, // Tamaño máximo cuando está deslizado hacia arriba

            builder: (BuildContext context, ScrollController scrollController) {
              return Stack(
                clipBehavior: Clip.none, // Permite que el Positioned sobresalga
                children: [
                  // Contenedor principal
                  Container(
                    decoration: ContainerStyle.bottomContainerDec(),
                    margin: EdgeInsets.only(
                      top: screenHeight * 0.1,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.03),

                        // Título ingredientes
                        ingredientesTitle(screenWidth, screenHeight),

                        // Lista de ingredientes
                        ingredientsList(
                            screenHeight, scrollController, screenWidth),
                        // Botones
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            bottomButtons("Agregar a la lista"), 
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> Tutorial(ingredients: ing,steps: steps,name: name,)));
                              },
                              child: Container(
                                decoration: ContainerStyle.buttonContainerDec(),
                                padding:const EdgeInsets.all(10),
                                child: Text(
                                  "Todo listo",
                                  style: Textstyles.normalStyle(),
                                ),
                              ),
                            )
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
    final chatProvider = context.watch<ChatProvider>();

    return Positioned(
      top: screenHeight * 0.07,
      left: screenWidth * 0.1,
      right: screenWidth * 0.1,
      child: Container(
          height: screenHeight * 0.08,
          padding: EdgeInsets.symmetric(vertical:screenHeight*0.01),
          decoration: ContainerStyle.buttonContainerDec(),
          child: SingleChildScrollView(
            child: Text(chatProvider.recipeNamesList.last,style: Textstyles.titleStyle(),textAlign: TextAlign.center,),
          ),
        ),
    );
  }

  InkWell bottomButtons (String message){
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: ContainerStyle.buttonContainerDec(),
        padding:const EdgeInsets.all(10),
        child: Text(
          message,
          style: Textstyles.normalStyle(),
        ),
      ),
    );
  }

  SizedBox ingredientsList(double screenHeight,
      ScrollController scrollController, double screenWidth) {
    return SizedBox(
      height: screenHeight * 0.6,
      child: Expanded(
        child: ListView.builder(
          controller: scrollController,
          itemCount: ing.length,
          itemBuilder: (context, index) {
            // String name = ingredients[index].keys.first;
            // int amount = ingredients[index][name]!;

            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "• ${ing[index]}",
                      style: Textstyles.normalStyle(),
                      softWrap: true,
                    ),
                  ),
                  // ------ Boton de editar
                  IconButton(
                    onPressed: () {
                      editSection(context, screenHeight, screenWidth, index);
                    },
                    icon: Image.asset(
                      "assets/icons/edit2.png",
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

  Future<dynamic> editSection(BuildContext context, double screenHeight,
    double screenWidth, int index) {
    nameControl.text = ing[index].substring(2);
    amountControl.text = ing[index][0];

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que el teclado suba el BottomSheet
      builder: (BuildContext context) {
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // Ajuste del espacio con el teclado
            ),
            child: Container(
              alignment: Alignment.bottomLeft,
              height: screenHeight * 0.35,
              decoration: ContainerStyle.bottomContainerDec(),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Permite que el contenido se ajuste al teclado
                children: [
                  editarIngredienteTitle(screenHeight, screenWidth),
                  Row(
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      Container(
                        width: screenWidth * 0.2,
                        margin: EdgeInsets.only(
                          left: screenWidth * 0.08,
                          right: screenWidth * 0.02,
                        ),
                        child: TextField(
                          controller: amountControl,
                          decoration: InputStyle.inputDecoration("Cantidad"),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.6,
                        child: TextField(
                          controller: nameControl,
                          decoration: InputStyle.inputDecoration("Nombre"),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              limpiar();
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: ContainerStyle.buttonContainerDec(),
                            child: Text("Cancelar", style: Textstyles.buttonStyle()),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              String newKey = nameControl.text.toString();
                              String newAmo = amountControl.text.toString();
                              String newIng = "$newAmo $newKey";
                              ing[index] = newIng;
                              limpiar();
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: ContainerStyle.buttonContainerDec(),
                            child: Text("Continuar", style: Textstyles.buttonStyle()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      limpiar();
                      ing.removeAt(index);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                      decoration: ContainerStyle.buttonContainerDec(),
                      child: Text("Borrar", style: Textstyles.buttonStyle()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Padding editarIngredienteTitle(double screenHeight, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.1,
        right: screenWidth * 0.1,
      ),
      child: const Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Editar Ingrediente",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Poppins",
              fontSize: 26,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Padding ingredientesTitle(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.03,
        top: screenHeight * 0.03,
      ),
      child: Row(
        children: [
          Text(
            "Ingredientes:",
            style: Textstyles.titleStyle(),
          ),
        ],
      ),
    );
  }


}
