import 'package:cooking_hub/presentation/screens/iniciarSesion.dart';
import 'package:cooking_hub/presentation/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:cooking_hub/widgets/shared/background_image.dart';
import 'package:cooking_hub/widgets/styles/containerStyle.dart';
import 'package:cooking_hub/widgets/styles/textStyles.dart';

class Start extends StatefulWidget{
  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {

  double opacity = 0.0;


  @override
  void initState() {
    super.initState();
    startFade();
  }

  void startFade(){
    Future.delayed(const Duration(milliseconds: 300),(){
      setState(() {
        opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: AnimatedOpacity(
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
          opacity: opacity,
          
          child: Stack(
            children: [
              StartBackgroundImage(),
          
              Center(
                child: Expanded(child: Text("COOKING HUB", style: Textstyles.centerTitle(), textAlign: TextAlign.center,)),
              ),
          
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterScreen()));
                      },
                      child: Container(
                        decoration: ContainerStyle.button2ContainerDec(),
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: screenWidth*0.2
                        ),
                        child: Text("Registrarse",style: Textstyles.buttonStyle(),),
                      ),
                    ),
                    
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> IniciarSesion()));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: screenWidth*0.2
                        ),
                        child: Text("Iniciar Sesion",style: Textstyles.buttonStyle(),),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(top:16.0),
                      child: Text("Terminos y condiciones", style: Textstyles.listsStyle2(),),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}