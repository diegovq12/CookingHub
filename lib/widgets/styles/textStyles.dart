import 'package:flutter/material.dart';

class Textstyles {
  
  // Genericos ----------
  
  static TextStyle normalStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 20);
  
  static TextStyle smallNormalStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 16);
  
  static TextStyle addStyle() => const TextStyle(color: Color.fromARGB(179, 255, 255, 255),fontFamily: "Poppins",fontSize: 20);
  
  // Listas ----------

  static TextStyle listsStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 20,decoration: TextDecoration.underline,decorationColor: Colors.white);
  
  static TextStyle smallListsStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 12,decoration: TextDecoration.underline,decorationColor: Colors.white);
  
  // Botones ----------

  // normal style but bold
  static TextStyle buttonStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 20,fontWeight: FontWeight.bold);

  // Titulos ----------

  // Font size 36
  static TextStyle titleStyle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 36, fontWeight: FontWeight.bold);
  
  // Font size 64
  static TextStyle bigTitle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 64, fontWeight: FontWeight.bold);
  
  // Font size 28
  static TextStyle smallTitle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 28, fontWeight: FontWeight.bold);

  // SemiBold ----------

  static TextStyle semiBoldStyle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 26, fontWeight: FontWeight.bold);

  // INICIO DE LA APLICACION
  static TextStyle centerTitle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 58, fontWeight: FontWeight.bold);

}