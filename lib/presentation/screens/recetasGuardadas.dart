import 'package:flutter/material.dart';
import 'package:cooking_hub/widgets/shared/background_image.dart';
import 'package:cooking_hub/widgets/shared/hot_bar.dart';
import 'package:cooking_hub/widgets/styles/textStyles.dart';
import 'package:cooking_hub/widgets/styles/containerStyle.dart';

class RecetasGuardadas extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _RecetasGuardadas();
}

class _RecetasGuardadas extends State<RecetasGuardadas>{
  
  List<String> recipes = [
    "Lista1","Lista2","Lista52"
  ];
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            BackgroundImage(),
            
            // Titulo
            Container(
              decoration: ContainerStyle.topContainerDec(),
              height: screenHeight*0.1,
              width: screenWidth,
              alignment: Alignment.center,
              child: Text("Recetas Guardadas",style: Textstyles.titleStyle(),),
            ),
            
            // Container principal de la lista
            Container(
              decoration: ContainerStyle.genContainerDec(),
              height: screenHeight,
              width: screenWidth,
              margin: EdgeInsets.only(top: screenHeight*0.15,),
              child: 
                recipesList(screenWidth, screenHeight),
            ),

            InkWell(
              onTap: (){

              },
              child: Container(
                decoration: ContainerStyle.buttonContainerDec(),
                padding: EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8
                ),
                margin: EdgeInsets.only(
                  top: screenHeight*0.13,
                  left: screenWidth*0.03
                ),
                child: Icon(Icons.add,color: Colors.white,),
              ),
            ),

            HotBar(),
          ],
        ),
      )
    );
  }

  Container recipesList(double screenWidth, double screenHeight) {
    return Container(
                margin: EdgeInsets.only(left: screenWidth*0.02),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: screenHeight*0.02,),
                    Expanded(
                      child: ListView.builder(
                        itemCount: recipes.length,
                        itemBuilder: (context,index){
                          return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RecetaGS()));
                                  },
                                  child: Text("• ${recipes[index]}", style: Textstyles.normalStyle(),)
                                ),
                                InkWell(
                                  onTap: (){

                                  },
                                  child: Container(
                                    decoration: ContainerStyle.buttonContainerDec(),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 8
                                    ),
                                    child: Image.asset("assets/icons/delete.png",width: screenHeight*0.02,),
                                  )
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                    )
                  ],
                ),
              );
  }

}

class RecetaGS extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _RecetaGS();
}

class _RecetaGS extends State<RecetaGS>{
  
  List<String>ingredients=["1 Manzana","1 Manzana","1 Manzana"];
  List<String>tutorial=["1 amazar","2 aplanar","3 disfrutar"];
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            BackgroundImage(),

            Container(
              decoration: ContainerStyle.topContainerDec(),
              height: screenHeight*0.1,
              width: screenWidth,
              alignment: Alignment.center,
              child: Text("RecetaSeleccionada",style: Textstyles.titleStyle(),),
            ),

            Container(
              decoration: ContainerStyle.genContainerDec(),
              height: screenHeight,
              width: screenWidth,
              margin: EdgeInsets.only(top: screenHeight*0.15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: screenHeight*0.03,),

                  Text("Ingredientes",style: Textstyles.titleStyle(),),
                  
                  ingredientsList(screenHeight),

                  Text("Procedimiento",style: Textstyles.titleStyle(),),

                  tutorialList(screenHeight),
                ],
              ),
            ),

            cotizarButton(screenHeight, screenWidth),

            HotBar()
          ],
        ),
      )
    );
  }

  Expanded ingredientsList(double screenHeight) {
    return Expanded(
                  child: ListView.builder(
                    itemCount: ingredients.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("• ${ingredients[index]}",style: Textstyles.normalStyle(),),
                            InkWell(
                              onTap: (){

                              },
                              child: Container(
                                decoration: ContainerStyle.buttonContainerDec(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 8
                                ),
                                child: Image.asset("assets/icons/edit2.png",width: screenHeight*0.02,),
                              )
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                );
  }

  Expanded tutorialList(double screenHeight) {
    return Expanded(
                  child: ListView.builder(
                    itemCount: tutorial.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(tutorial[index],style: Textstyles.normalStyle(),),
                            InkWell(
                              onTap: (){

                              },
                              child: Container(
                                decoration: ContainerStyle.buttonContainerDec(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 8
                                ),
                                child: Image.asset("assets/icons/edit2.png",width: screenHeight*0.02,),
                              )
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                );
  }

  Align cotizarButton(double screenHeight, double screenWidth) {
    return Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: (){
            
              },
              child: Container(
                decoration: ContainerStyle.buttonContainerDec(),
                margin: EdgeInsets.only(bottom: screenHeight*0.07),
                width: screenWidth*0.5,
                height: screenHeight*0.05,
                alignment: Alignment.center,
                child: Text("Cotizar",style: Textstyles.normalStyle(),),
              ),
            ),
          );
  }

}
