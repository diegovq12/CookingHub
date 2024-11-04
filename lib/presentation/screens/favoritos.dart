import 'package:flutter/material.dart';
import 'package:cooking_hub/presentation/screens/listaCompras.dart';
import 'package:cooking_hub/presentation/screens/recetas.dart';

class favoritos extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _favoritos();
}

class _favoritos extends State<favoritos>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          backgroundImage(),
          HotBar(),
        ],
      ));
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