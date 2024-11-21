import 'package:flutter/material.dart';
import 'package:cooking_hub/widgets/shared/hot_bar.dart';
// import 'package:cooking_hub/services/openai_services.dart';
import 'package:cooking_hub/presentation/providers/chat_provider.dart';
import 'package:provider/provider.dart';
// import 'package:cooking_hub/presentation/screens/listaCompras.dart';
// import 'package:cooking_hub/presentation/screens/recetas.dart';

class ingredientes extends StatefulWidget {
  const ingredientes({super.key});

  @override
  State<StatefulWidget> createState() => _ingredientes();
}

class _ingredientes extends State<ingredientes> {
  // -------- Lista -------- //
  List<String> ing = [];

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

  // Almacena el chambio que envia, mas no bien actualiza el mapa solo guarda el texto
  void saveChange(String texto, int index) {
    setState(() {
      // ingredients[index] = texto.;
      nameControl.clear();
      amountControl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    // Almaecnar la receta
    ing = chatProvider.recipeList;

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
          // --- Fondo - imagen
          BackGroundImage(),

          // --- Fondo con la lista
          DraggableScrollableSheet(
            initialChildSize: 0.5, // Tamaño inicial del contenedor
            minChildSize:
                0.5, // Tamaño mínimo cuando está deslizado hacia abajo
            maxChildSize: 1, // Tamaño máximo cuando está deslizado hacia arriba

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
                        SizedBox(height: screenHeight * 0.03),

                        // Título ingredientes
                        ingredientesTitle(screenWidth, screenHeight),

                        // Lista de ingredientes
                        ingredientsList(
                            screenHeight, scrollController, screenWidth),
                        // Botones
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [addToListButton(), allSetButton()],
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
      top: screenHeight * 0.07, // Ajusta para sobresalir en la parte superior
      left: screenWidth * 0.1,
      right: screenWidth * 0.1,
      child: Expanded(
          child: Container(
            height: screenHeight * 0.08, // Provide a bounded height
            decoration: titleDecoration(),
            child: Center(
              child: chatProvider.recipeNamesList.isEmpty
                  ? Text(
                      "", // Mostrar nada si la lista esta vacía
                      style: titleStyle(),
                      textAlign: TextAlign.center,
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 1, 
                      itemBuilder: (context, index) {
                        return Center(
                          child: Text(
                            chatProvider
                                .recipeNamesList.last, // Mostrar el ultimo elemento
                            style: titleStyle(),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      );
  }

  InkWell allSetButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: titleDecoration(),
        padding: EdgeInsets.all(10),
        child: Text(
          "Todo listo",
          style: normalStyle(),
        ),
      ),
    );
  }

  InkWell addToListButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: titleDecoration(),
        padding: EdgeInsets.all(10),
        child: Text(
          "Agregar a la lista",
          style: normalStyle(),
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
                      style: normalStyle(),
                      softWrap: true,
                    ),
                  ),
                  // ------ Boton de editar
                  IconButton(
                    onPressed: () {
                      editSection(context, screenHeight, screenWidth, index);
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
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom, // Ajuste del espacio con el teclado
            ),
            child: Container(
              alignment: Alignment.bottomLeft,
              height: screenHeight * 0.35,
              decoration: backgroundDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // Permite que el contenido se ajuste al teclado
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
                          decoration: inputBoxAmount(),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.6,
                        child: TextField(
                          controller: nameControl,
                          decoration: inputBoxName(),
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
                            decoration: titleDecorationWithShadow(),
                            child: Text("Cancelar", style: buttonStyle()),
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
                            decoration: titleDecorationWithShadow(),
                            child: Text("Continuar", style: buttonStyle()),
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
                      decoration: titleDecorationWithShadow(),
                      child: Text("Borrar", style: buttonStyle()),
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

  TextStyle normalStyle() =>
      const TextStyle(color: Colors.white, fontFamily: "Poppins", fontSize: 20);

  TextStyle buttonStyle() => const TextStyle(
      color: Colors.white,
      fontFamily: "Poppins",
      fontSize: 20,
      fontWeight: FontWeight.bold);

  TextStyle titleStyle() => const TextStyle(
      color: Colors.white,
      fontFamily: "Poppins",
      fontSize: 36,
      fontWeight: FontWeight.bold);

  InputDecoration inputBoxAmount() {
    return const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: "Cantidad",
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none));
  }

  InputDecoration inputBoxName() {
    return const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: "Ingrediente",
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none));
  }

  BoxDecoration titleDecoration() {
    return const BoxDecoration(
        color: Color.fromRGBO(255, 131, 48, 1),
        borderRadius: BorderRadius.all(Radius.circular(16)));
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
              offset: Offset(0, 2))
        ]);
  }
}

// class HotBar extends StatelessWidget {
//   const HotBar({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(

//         decoration: const BoxDecoration(
//         color: Color.fromRGBO(255, 170, 50, 1),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(16),
//           topRight: Radius.circular(16)
//           )
//         ),

//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(onPressed: (){}, icon: Image.asset("assets/HotBar/Home.png",width: 30,)),
//             IconButton(onPressed: (){}, icon: Image.asset("assets/HotBar/Games.png",width: 30,)),
//             Positioned(
//               child: IconButton(onPressed: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=> const Recetas()));
//               },
//               padding: const EdgeInsets.only(
//                 bottom: 2
//               ),
//               icon: Image.asset("assets/HotBar/Gorrito.png",width: 50,)) ,
//               ),
//             IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const ListaScreen()));},
//             icon: Image.asset("assets/HotBar/Lista.png",width: 30,),),
//             IconButton(onPressed: (){}, icon: Image.asset("assets/HotBar/Perfil.png",width: 30,)),
//           ],
//         ),
//       ),
//     );
//   }
// }

class BackGroundImage extends StatelessWidget {
  const BackGroundImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/Background.png"), fit: BoxFit.cover)),
    );
  }
}
