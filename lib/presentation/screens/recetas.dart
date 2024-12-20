import 'package:cooking_hub/presentation/screens/FueraDeServicio.dart';
import 'package:cooking_hub/widgets/shared/hot_bar.dart';
import 'package:cooking_hub/widgets/styles/containerStyle.dart';
import 'package:flutter/material.dart';
import 'package:cooking_hub/presentation/screens/favoritos.dart';
import 'package:cooking_hub/widgets/shared/background_image.dart';
import 'package:cooking_hub/presentation/screens/chat_screen.dart';


class Recetas extends StatefulWidget{
  const Recetas({super.key});

  @override
  State<StatefulWidget> createState() => _Recetas();
}

class _Recetas extends State<Recetas>{
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(child: Scaffold(
      body: Stack(
        children: [
          // Fondo
          BackgroundImage(),
          
          // Titulo de Recetas
          titleRecetas(screenHeight, screenWidth),

          // Secciones
          Container(
            margin:  EdgeInsets.only(
              top: screenHeight*0.15,
            ),

            child: Column(
              children: [
                // --------- Lista superior -------- //
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: screenHeight*0.15,
                    
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          cameraButton(context,screenWidth),
                    
                          chatButton(context,screenWidth),
                          
                        ],
                      ),
                    ),
                  ]
                ),
                // --------- Favoritos
                favoritesButton(screenHeight, screenWidth),
                // --------- Recetas semanales 
                seasonButton(screenHeight, screenWidth),
              ],
            ),
          ),


          // Hot Bar
          const HotBar()
        ],
      ),
    ));
  }

  Container titleRecetas(double screenHeight, double screenWidth) {
    return Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(255, 168, 50, 1),
            borderRadius: BorderRadius.all(Radius.circular(16))
          ),
          
          height: screenHeight*0.07,

          margin:  EdgeInsets.only(
            top: screenHeight*0.02,
            left: screenWidth*0.03,
            right: screenWidth*0.03
          ),

          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Recetas", style: 
            TextStyle(color: Colors.white, fontFamily: "Poppins", 
            fontSize: 36, fontWeight: FontWeight.bold),)],
          ),
        );
  }

  Row favoritesButton(double screenHeight, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
      Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16))
        ),

        margin: const EdgeInsets.only(
            top: 20,
            left:16,
            right:16,
            bottom:16,
          ),

        child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Favoritos()));
          },
          child: Container(
                height: screenHeight*0.2,
                width: screenWidth*0.85,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  image: DecorationImage(image: AssetImage("assets/HotCakes.png"),
                  fit: BoxFit.cover)
                ),


                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Image.asset("assets/icons/star.png",width: screenWidth*0.2,),
                  SizedBox(width: screenWidth*0.05,),
                  Text("Favoritos",style: titleStyle(),)
                ],
              ),
            ),
          )
        ),
      ],
    );
  }
  
  Row seasonButton(double screenHeight, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
      Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16))
        ),

        margin: const EdgeInsets.all(16),

        child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const outOfService()));
          },
          child: Container(
                height: screenHeight*0.25,
                width: screenWidth*0.85,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  image: DecorationImage(image: AssetImage("assets/Arepas.png"),
                  fit: BoxFit.cover)
                ),


                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Image.asset("assets/icons/eat.png",width: screenWidth*0.2,),
                  SizedBox(width: screenWidth*0.05,),
                  Text("Platos de \ntemporada",style: titleStyle(),)
                ],
              ),
            ),
          )
        ),
      ],
    );
  }

  TextStyle titleStyle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 36, fontWeight: FontWeight.bold);

  TextStyle normalStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 20);

  Expanded chatButton(BuildContext context,double screenWidth) {
    return Expanded(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen()));
          },

          child: Container(
            decoration: ContainerStyle.genContainerDec(),
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/icons/chat.png",width: screenWidth*0.1,),
                Text("Chat",style: normalStyle(),)
              ]
            ),
          ),
        ),
      )
    );
  }

  Expanded cameraButton(BuildContext context,double screenWidth) {
    return Expanded(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: InkWell(
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(builder: (context)=> CamaraTiempoReal()));
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const outOfService()));
            
          },
          child: Container(
            decoration: ContainerStyle.genContainerDec(),
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Image.asset("assets/icons/camera.png",width: screenWidth*0.1,),
                Text("Camara",style: normalStyle(),)
              ],
            ),
          ),
        ),
      )
    );
  }

  BoxDecoration buttonDecoration() {
    return const BoxDecoration(
            color:Color.fromARGB(255, 241, 141, 0),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          );
  }

}