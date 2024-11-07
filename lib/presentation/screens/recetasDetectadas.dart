import 'package:flutter/material.dart';
import 'package:cooking_hub/presentation/screens/listaCompras.dart';
import 'package:cooking_hub/presentation/screens/recetas.dart';

class recetasDetectadas extends StatefulWidget{
  const recetasDetectadas({super.key});

  @override
  State<StatefulWidget> createState() => _recetasDetectadas();
}

class _recetasDetectadas extends State<recetasDetectadas>{
  
  // -------- Lista de recetas -------- //
  List<String> recetasObtenidas = [
    "Receta 1"
  ];

  // Habria que modificar los campos y el tipo de variables en la lista para que te envie a la receta
  void add_recipe(String name_recipe){
    setState(() {
      recetasObtenidas.add(name_recipe);
    });
  }

  @override
  Widget build(BuildContext context) {

    // Cuando quieras agregar una receta lo puedes hacer asi
    add_recipe("Receta 2");
    add_recipe("Receta 3");

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(child: Scaffold(
      body: Stack(
        children: [
          // Imagen de Fondo 
          backgroundImage(),
          
          // Fondo con el listado de recetas
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16))
            ),

            margin:  EdgeInsets.only(
              top: screenHeight*0.09,
              right: screenWidth*0.02,
              left: screenWidth*0.02,
              bottom: 60
            ),

            width: screenWidth,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: recetasObtenidas.length,
                    itemBuilder: (context, index){
                      final current_item = recetasObtenidas[index];
                      return ListTile(
                        title: recipeButton(screenHeight, current_item)
                      );
                    }
                  )
                )
              ],
            ),

          ),
          
          // Titulo de Recetas
          recipeTitle(screenHeight),
          
          HotBar()
        ],
      ),
    )
    );
  }

  Container recipeTitle(double screenHeight) {
    return Container(
          decoration: const BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.all(Radius.circular(16))
          ),
          
          margin: const EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10
          ),

          width: double.infinity,
          height: screenHeight*0.08,
          
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Recetas",
              style: titleStyle())
            ],
          ),
        );
  }

  Container backgroundImage() {
    return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/Background.png"),
            fit: BoxFit.cover)
          ),
        );
  }

  TextStyle recipeStyle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 36, fontWeight: FontWeight.w500);

  TextStyle titleStyle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 48, fontWeight: FontWeight.bold);

  InkWell recipeButton(double screenHeight, String current_item) {
    return InkWell(
                        onTap: (){},
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFA832),
                            borderRadius: BorderRadius.all(Radius.circular(16))
                          ),

                          margin:  EdgeInsets.only(
                            top: screenHeight*0.02,
                          ),

                          height: screenHeight*0.06,

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(current_item,
                                style: recipeStyle()),
                                Image.asset("assets/icons/eat.png",width: screenHeight*0.05,)
                            ],
                          ),
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