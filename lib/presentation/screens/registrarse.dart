import 'package:cooking_hub/presentation/screens/iniciarSesion.dart';
import 'package:flutter/material.dart';
import 'package:cooking_hub/widgets/shared/background_image.dart';
import 'package:cooking_hub/widgets/styles/containerStyle.dart';
import 'package:cooking_hub/widgets/styles/textStyles.dart';

class Registrarse extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _Registrarse();

}

class _Registrarse extends State<Registrarse>{

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool terms = false;

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

            Container(
              margin: EdgeInsets.only(top: 32,left: 12,right: 12),
              width: screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Registrate",style: Textstyles.titleStyle2(),),
                  Text("Y empieza a cocinar de manera creativa",style: Textstyles.normalStyle2(),),
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: ContainerStyle.bottomContainerDec(),
                height: screenHeight*0.8,
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32, left: 12, right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Ya tienes cuenta? ",style: Textstyles.normalStyle(),),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> IniciarSesion()));
                            },
                            child: Text("Inicia sesion",style: Textstyles.listsStyle(),)
                          ),
                        ],
                      ),

                      TextField(
                        controller: nameController,
                        decoration: ContainerStyle.inputDecoration("Nombre de usuario"),
                      ),
                      
                      TextField(
                        controller: emailController,
                        decoration: ContainerStyle.inputDecoration("Correo electronico"),
                      ),
                      
                      TextField(
                        controller: passwordController,
                        decoration: ContainerStyle.inputDecoration("Contraseña"),
                      ),
                      
                      TextField(
                        controller: confirmPasswordController,
                        decoration: ContainerStyle.inputDecoration("Confirmar contraseña"),
                      ),

                      Row(
                        children: [
                          Checkbox(
                            value: terms, 
                            onChanged: (bool? value){
                              setState(() {
                                terms = value!;
                              });
                            },
                          ),
                          Text("He leido y acepto los Terminos y condiciones", style: Textstyles.listsStyle2(),)
                        ],
                      ),

                      Text("O usa una de estas opciones", style: Textstyles.normalStyle(),),
                      
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
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
                            if(nameController.text == "" || emailController.text == "" || passwordController.text == "" || confirmPasswordController.text == ""){
                              showMessange(context, screenWidth, screenHeight, "Porfavor llenar todos los campos");
                            }
                            if(passwordController.text != confirmPasswordController.text){
                              showMessange(context, screenWidth, screenHeight, "Confirmacion de contraseña incorrecta, ambos campos deben ser iguales");
                            }
                            if(!terms){
                              showMessange(context, screenWidth, screenHeight, "Porfavor acepte los terminos y condiciones");
                            }
                          },
                          child: Text("Registrarte",style: Textstyles.buttonStyle(),)
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

}