import 'package:flutter/material.dart';
import 'package:cooking_hub/presentation/screens/recetas.dart';


class ListaScreen extends StatefulWidget{
  const ListaScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ListaScreen();
}

class _ListaScreen extends State<ListaScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/Background.png"),
                fit: BoxFit.cover)
              ),
            ),
             // Hot Bar
              Align(
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
                      const SizedBox(width: 60,),
                      IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const ListaScreen()));}, 
                      icon: Image.asset("assets/HotBar/Lista.png",width: 30,),),
                      IconButton(onPressed: (){}, icon: Image.asset("assets/HotBar/Perfil.png",width: 30,)),
                    ],
                  ),
                ),
              ),
              
              // Icono central
              Align(
                alignment: Alignment.bottomCenter,
                child: Positioned(
                  child: IconButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Recetas()));
                  },
                  padding: const EdgeInsets.only(
                    bottom: 2
                  ), 
                  icon: Image.asset("assets/HotBar/Gorrito.png",width: 50,)) ,
                  ),
              ),
          ],
        )
      ),
    );
  }
}
