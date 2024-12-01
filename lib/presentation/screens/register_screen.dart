import 'package:cooking_hub/presentation/screens/iniciarSesion.dart';

import 'package:cooking_hub/services/user_service.dart';
import 'package:cooking_hub/widgets/styles/inputStyle.dart';
import 'package:flutter/material.dart';
import 'package:cooking_hub/widgets/shared/background_image.dart';
import 'package:cooking_hub/widgets/styles/containerStyle.dart';
import 'package:cooking_hub/widgets/styles/textStyles.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool terms = false;

  // Expresiones regulares para validaciones
  final String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  final String passwordRegex =
      r'^(?=.*[A-Z])(?=.*[!@#$%^&*.])[A-Za-z\d!@#$%^&*.]{8,}$';

  void showMessage(BuildContext context, double screenWidth,
      double screenHeight, String message) {
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

  bool seePaswoard = true;
  bool seeConfPaswoard = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            BackgroundImage(),

            Padding(
              padding: EdgeInsets.only(top: screenHeight*0.03),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Registrate", style: Textstyles.titleStyle()),
                    Text("Y empieza a cocinar de manera creativa",
                        style: Textstyles.normalStyle2()),
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Container(
                  decoration: ContainerStyle.bottomContainerDec(),
                  height: screenHeight * 0.8,
                  width: screenWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32, left: 12, right: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Ya tienes cuenta? ",
                                style: Textstyles.normalStyle()),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => IniciarSesion()),
                                );
                              },
                              child: Text("Inicia sesión",
                                  style: Textstyles.listsStyle()),
                            ),
                          ],
                        ),
                        TextField(
                          controller: nameController,
                          decoration:
                              InputStyle.inputDecoration("Nombre de usuario"),
                        ),
                        TextField(
                          controller: emailController,
                          autocorrect: false,
                          decoration: InputStyle.inputDecoration(
                              "Correo electrónico"),
                        ),
                        TextField(
                          controller: passwordController,
                          autocorrect: false,
                          decoration:
                              passwoardInputDecoration("Contraseña",seePaswoard),
                          obscureText: seePaswoard,
                        ),
                        TextField(
                          controller: confirmPasswordController,
                          autocorrect: false,
                          decoration: confPasswoardInputDecoration(
                              "Confirmar contraseña",seeConfPaswoard),
                          obscureText: seeConfPaswoard,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: terms,
                              onChanged: (bool? value) {
                                setState(() {
                                  terms = value!;
                                });
                              },
                            ),
                            Text("He leído y acepto los términos y condiciones",
                                style: Textstyles.listsStyle2())
                          ],
                        ),
                        Text("O usa una de estas opciones",
                            style: Textstyles.normalStyle()),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: screenWidth * 0.3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  showMessage(context, screenWidth, screenHeight,
                                      "No disponible por ahora");
                                },
                                child: Image.asset("assets/icons/facebook.png",
                                    width: screenWidth * 0.1),
                              ),
                              InkWell(
                                onTap: () {
                                  showMessage(context, screenWidth, screenHeight,
                                      "No disponible por ahora");
                                },
                                child: Image.asset("assets/icons/google.png",
                                    width: screenWidth * 0.1),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: ContainerStyle.button2ContainerDec(),
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.01),
                          child: InkWell(
                            onTap: () async {
                              // Validaciones antes de proceder
                              if (nameController.text == "" ||
                                  emailController.text == "" ||
                                  passwordController.text == "" ||
                                  confirmPasswordController.text == "") {
                                showMessage(context, screenWidth, screenHeight,
                                    "Por favor, llena todos los campos.");
                              } else if (!RegExp(emailRegex)
                                  .hasMatch(emailController.text)) {
                                showMessage(context, screenWidth, screenHeight,
                                    "Por favor, ingresa un correo electrónico válido.");
                              } else if (passwordController.text !=
                                  confirmPasswordController.text) {
                                showMessage(context, screenWidth, screenHeight,
                                    "Confirmación de contraseña incorrecta.");
                              } else if (!terms) {
                                showMessage(context, screenWidth, screenHeight,
                                    "Por favor, acepta los términos y condiciones.");
                              } else if (!RegExp(passwordRegex)
                                  .hasMatch(passwordController.text)) {
                                showMessage(context, screenWidth, screenHeight,
                                    "La contraseña debe tener al menos 8 caracteres, 1 mayúscula y 1 carácter especial.");
                              } else {
                                // Validación adicional con la base de datos
                                String validationMessage =
                                    await UserService().checkIfUserExists(
                                  nameController.text,
                                  emailController.text,
                                );
                
                                if (validationMessage != "Disponible") {
                                  showMessage(context, screenWidth,
                                      screenHeight, validationMessage);
                                } else {
                                  // Llamada a la función de registro
                                  String result =
                                      await UserService().registerUser(
                                    nameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    confirmPasswordController.text,
                                  );
                                  showMessage(
                                      context, screenWidth, screenHeight, result);
                
                                  // Si el registro es exitoso, redirige a la pantalla de inicio de sesión
                                  if (result == 'Usuario registrado exitosamente'){
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => IniciarSesion()),
                                    );
                                  }
                                }
                              }
                            },
                            child: Text("Registrarte",
                                style: Textstyles.buttonStyle()),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration passwoardInputDecoration(String placeHolder, bool show) {
    return InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: placeHolder,
        hintStyle: TextStyle(color: Colors.grey),
        suffixIcon: IconButton(
          onPressed: (){
            setState(() {
              seePaswoard = !seePaswoard;
            });
          }, 
          icon: Icon(show? Icons.visibility_off : Icons.visibility, color: Colors.grey,)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none));
  }
  
  InputDecoration confPasswoardInputDecoration(String placeHolder, bool show) {
    return InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: placeHolder,
        hintStyle: TextStyle(color: Colors.grey),
        suffixIcon: IconButton(
          onPressed: (){
            setState(() {
              seeConfPaswoard = !seeConfPaswoard;
            });
          }, 
          icon: Icon(show? Icons.visibility_off : Icons.visibility, color: Colors.grey,)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none));
  }

}
