import 'package:cooking_hub/presentation/screens/ingredientes.dart';
// import 'package:cooking_hub/presentation/screens/lista_compras.dart';
import 'package:cooking_hub/presentation/screens/recetas.dart';
import 'package:flutter/material.dart';

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
            // -------- HOME -------- //
            IconButton(onPressed: (){
              
            }, icon: Image.asset("assets/HotBar/Home.png",width: 30,)),
            
            // -------- Games -------- //
            IconButton(onPressed: (){
              // Navigator.push(context, MaterialPageRoute(builder: (context)=> const ingredientes()));
            }, icon: Image.asset("assets/HotBar/Games.png",width: 30,)),
            
            // -------- Recetas -------- //
            Positioned(
              child: IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const Recetas()));
              },
              padding: const EdgeInsets.only(
                bottom: 2
              ), 
              icon: Image.asset("assets/HotBar/Gorrito.png",width: 50,)) ,
              ),
            // -------- Lista de compras -------- //
            IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const ingredientes()));}, 
            icon: Image.asset("assets/HotBar/Lista.png",width: 30,),),

            // -------- Perfil -------- //
            IconButton(onPressed: (){}, icon: Image.asset("assets/HotBar/Perfil.png",width: 30,)),
          ],
        ),
      ),
    );
  }
}