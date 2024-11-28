import 'package:cooking_hub/presentation/screens/recetas.dart';
import 'package:cooking_hub/presentation/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:cooking_hub/widgets/shared/background_image.dart';
import 'package:cooking_hub/widgets/styles/containerStyle.dart';
import 'package:cooking_hub/widgets/styles/textStyles.dart';

class IniciarSesion extends StatefulWidget{
  const IniciarSesion({super.key});

  @override
  State<StatefulWidget> createState() => _IniciarSesion();
}

class _IniciarSesion extends State<IniciarSesion>{
  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void showMessange(BuildContext context, double screenWidth, double screenHeight, String messange){
    showDialog(
      context: context, 
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5), 
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Color(0xFFFF8330),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(messange,style: Textstyles.normalStyle(),),
          ),
        );
      }
    );
  }
  
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
                child: Text("Bienvenido a \nCooking Hub", style: Textstyles.titleStyle(),),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: ContainerStyle.bottomContainerDec(),
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
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterScreen()));
                          },
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
                          controller: passwordController,
                          decoration: inputDecoration("Contraseña"),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 32),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: (){
                                showMessange(context, screenWidth, screenHeight, "No disponible por ahora");
                              },
                              child: Text("Olvide mi contraseña", style: Textstyles.listsStyle2(),)
                            ),
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
                              onTap: (){
                                showMessange(context, screenWidth, screenHeight, "No disponible por ahora");
                              },
                              child: Image.asset("assets/icons/facebook.png", width: screenWidth*0.1,)
                            ),
                            InkWell(
                              onTap: (){
                                showMessange(context, screenWidth, screenHeight, "No disponible por ahora");
                              },
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
                        child: InkWell(
                          onTap: (){
                            if(emailController.text == "" || passwordController.text == ""){
                              showMessange(context, screenWidth, screenHeight, "Por favor llenar los campos correo y contraseña");
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> Recetas()));
                            }
                            // --- aqui haria falta una verificacion de datos por parte de la base de datos
                          },
                          child: Text("Iniciar Sesion", style: Textstyles.buttonStyle(),)
                          ),
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