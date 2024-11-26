import 'package:flutter/material.dart';
import 'package:cooking_hub/widgets/shared/background_image.dart';
import 'package:cooking_hub/widgets/shared/hot_bar.dart';
import 'package:cooking_hub/widgets/styles/containerStyle.dart';
import 'package:cooking_hub/widgets/styles/textStyles.dart';

class LogginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LogginScreen();
}

class _LogginScreen extends State<LogginScreen>{
  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            BackgroundImage(),

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Bienvenido a Cooking Hub", style: Textstyles.titleStyle(),),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: ContainerStyle.genContainerDec(),
                height: screenHeight*0.7,
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text("Aun no tienes cuenta? ", style: Textstyles.normalStyle(),),
                        InkWell(
                          onTap: (){},
                          child: Text("Registrate", style: Textstyles.listsStyle(),)
                        ),
                      ],),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          
                          vertical: 28
                        ),
                        child: TextField(
                          controller: emailController,
                          decoration: inputDecoration("Correo electronico"),
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          
                          vertical: 28
                        ),
                        child: TextField(
                          controller: emailController,
                          decoration: inputDecoration("Contraseña"),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 32),
                        child: Row(
                          children: [
                            Text("Olvide mi contraseña", style: Textstyles.listsStyle2(),),
                          ],
                        ),
                      ),

                      
                      Text("O usa una de estas opciones", style: Textstyles.normalStyle(),),
                      
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 32,
                          horizontal: screenWidth*0.3
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: (){},
                              child: Image.asset("assets/icons/facebook.png", width: screenWidth*0.1,)
                            ),
                            InkWell(
                              onTap: (){},
                              child: Image.asset("assets/icons/google.png", width: screenWidth*0.1,)
                            ),
                          ],
                        ),
                      ),

                      Container(
                        decoration: ContainerStyle.button2ContainerDec(),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth*0.04,
                          vertical: screenHeight*0.01
                        ),
                        child: Text("Iniciar Sesion", style: Textstyles.buttonStyle(),),
                      )
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      )
    );
  }

  InputDecoration inputDecoration(String placeHolder) {
    return InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      
                      hintText: placeHolder,
                      hintStyle: TextStyle(
                        color: Colors.grey
                      ),
                      
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide.none   
                      )
                    );
  }

}