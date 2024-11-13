import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:cooking_hub/widgets/shared/background_image.dart';
import 'package:cooking_hub/widgets/shared/hot_bar.dart';
import 'package:cooking_hub/widgets/styles/textStyles.dart';
import 'package:cooking_hub/widgets/styles/containerStyle.dart';

class Mercados extends StatefulWidget{
  const Mercados({super.key});

  @override
  State<StatefulWidget> createState() => _Mercados();

}

class _Mercados extends State<Mercados>{
  
  // List<String> mercados = ["Soriana","Soriana","Soriana"];
  List<Map<String,int>> mercados = [
    {"Soriana":250},
    {"Soriana":500},
    {"Soriana":5000},
    {"Soriana":500000},

  ];
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const BackgroundImage(),
        
            Container(
              decoration: ContainerStyle.topContainerDec(),
              
              height: screenHeight*0.1,
              width: screenWidth,
              
              alignment: Alignment.center,
              child: Text("Mercados",style: Textstyles.titleStyle(),),
            ),

            Container(
              decoration: ContainerStyle.genContainerDec(),
              
              margin: EdgeInsets.only(
                top: screenHeight*0.15,
              ),
              height: screenHeight,
              width: screenWidth,
              
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: screenHeight*0.02,),
                  Expanded(
                    child: mercadosList(mercados: mercados, screenHeight: screenHeight),
                  )
                ],
              ),
            ),

            HotBar(),
          ],
        ),
      )
    );
  }

}

class mercadosList extends StatelessWidget {
  const mercadosList({
    super.key,
    required this.mercados,
    required this.screenHeight,
  });

  final List<Map<String, int>> mercados;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mercados.length,
      itemBuilder: (context,index){
        String currentName = mercados[index].keys.first;
        String currentPrice ="PP\$" + mercados[index][currentName]!.toString();
        return ListTile(
          title: Column(
            children: [
              if(index == 0)...[
                Text("Recomendado",style: Textstyles.titleStyle(),),
                SizedBox(height: screenHeight*0.02,)
              ],
              if(index == 2)...[
                Container(
                  alignment: Alignment.center,
                  child: Text("Mas opciones",style: Textstyles.titleStyle(),)
                ),
                SizedBox(height: screenHeight*0.02,)
              ],
              InkWell(
                onTap: (){
    
                },
                child: Container(
                  decoration: ContainerStyle.buttonContainerDec(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(currentName,style: Textstyles.semiBoldStyle(),),
                      Text(currentPrice,style: Textstyles.semiBoldStyle(),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight*0.02,)
            ],
          ),
        );
      }
    );
  }
}