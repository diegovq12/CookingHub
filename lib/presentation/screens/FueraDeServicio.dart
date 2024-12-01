import 'package:cooking_hub/widgets/shared/hot_bar.dart';
import 'package:cooking_hub/widgets/styles/containerStyle.dart';
import 'package:cooking_hub/widgets/styles/textStyles.dart';
import 'package:flutter/material.dart';

class outOfService extends StatelessWidget{
  
  const outOfService({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFA832),
        body: Stack(
          children: [
            Container(
              decoration: ContainerStyle.genContainerDec(),
              margin: EdgeInsets.symmetric(horizontal: screenWidth*0.05),
              height: screenHeight,
              width: screenWidth,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Pagina aun no finalizada", style: Textstyles.titleStyle(), textAlign: TextAlign.center,),
                    Icon(Icons.visibility_off, color: Colors.white,)
                  ],
                ),
              ),
            ),

            const HotBar()
          ],
        )
      )
    );
  }

}