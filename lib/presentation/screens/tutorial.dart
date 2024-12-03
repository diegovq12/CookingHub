import 'dart:async';

import 'package:cooking_hub/presentation/screens/felicidades.dart';
import 'package:cooking_hub/presentation/screens/recetas.dart';
import 'package:cooking_hub/widgets/shared/background_image.dart';
import 'package:cooking_hub/widgets/styles/containerStyle.dart';
import 'package:cooking_hub/widgets/styles/textStyles.dart';
import 'package:flutter/material.dart';

class Tutorial extends StatefulWidget{
  final List<String> ingredients;
  final List<String> steps;
  final String name;

  const Tutorial({super.key, required this.ingredients, required this.steps,required this.name});

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  List<bool> done = [];

  @override
  void initState() {
    super.initState();

    for(int i=1;i<= widget.steps.length;i++){
      done.add(false);
    }
  }

  void showMessage(BuildContext context, double screenWidth,double screenHeight, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Color(0xFFFF8330),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(message, style: Textstyles.normalStyle()),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            const BackgroundImage(),

            Container(
              decoration: ContainerStyle.genContainerDec(),
              width: screenWidth,
              height: screenHeight,
              margin: EdgeInsets.only(top:screenHeight*0.08),
              padding: EdgeInsets.only(top: screenHeight*0.03),
              child: 
              Expanded(
                child: ListView.builder(
                  itemCount: widget.steps.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(index== 0)...[
                            Row(
                              children: [
                                Text("Pasos :", style: Textstyles.titleStyle(),textAlign: TextAlign.left,),
                              ],
                            )
                          ],
                          if(index >= 0)...[
                            Row(
                              children: [
                                Expanded(child: Text("${index}.-${widget.steps[index]}",style: Textstyles.normalStyle(),)),
                                Checkbox(
                                  value: done[index],
                                  hoverColor: Colors.white,
                                  checkColor: Colors.white,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      done[index] = value!;
                                    });
                                  })
                                ],
                            ),
                            
                            Image.asset("assets/gif/cook.gif", width: screenHeight*0.1,),
                            if(index == widget.steps.length - 1)...[
                              Container(
                                decoration: ContainerStyle.buttonContainerDec(),
                                margin: EdgeInsets.symmetric(
                                  vertical: screenHeight*0.02
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth*0.02,
                                  vertical: screenHeight*0.01
                                ),
                                child: InkWell(
                                  onTap: (){
                                    bool allDone = true;
                                    print(done);
                                    for(bool temp in done ){
                                      print(temp);
                                      if(temp == false){
                                        allDone = false;
                                        showMessage(context, screenWidth, screenHeight, "No has terminado la receta, porfavor marca las casillas como hechas");
                                        break;
                                      }
                                    }
                                    if(allDone){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Congratulations()));
                                    }
                                  },
                                  child: Text("Terminar receta",style: Textstyles.buttonStyle(),)
                                  ),
                              )
                            ]
                          ]
                        ],
                      )
                    );
                  },
                )
              )
            ),

            recipeTitle(screenWidth, screenHeight),
          
          ],
        ),
      )
    );
  }

  Container recipeTitle(double screenWidth, double screenHeight) {
    return Container(
            decoration: ContainerStyle.buttonContainerDec(),
            width: double.maxFinite,
            height: screenHeight*0.1,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth*0.01,
              vertical: screenHeight*0.02
            ),
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth*0.02,
              vertical: screenHeight*0.02
            ),
            child: SingleChildScrollView(child: Text(widget.name, style: Textstyles.titleStyle(),textAlign: TextAlign.center,)),
          );
  }
}