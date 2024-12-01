import 'package:flutter/material.dart';

class Textstyles {
  static TextStyle normalStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 20);
  
  static TextStyle normalStyle2() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 16);
  
  static TextStyle addStyle() => const TextStyle(color: Color.fromARGB(179, 255, 255, 255),fontFamily: "Poppins",fontSize: 20);
  
  static TextStyle listsStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 20,decoration: TextDecoration.underline,decorationColor: Colors.white);
  
  static TextStyle listsStyle2() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 12,decoration: TextDecoration.underline,decorationColor: Colors.white);
  
  static TextStyle buttonStyle() => const TextStyle(color: Colors.white,fontFamily: "Poppins",fontSize: 20,fontWeight: FontWeight.bold);

  static TextStyle titleStyle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 36, fontWeight: FontWeight.bold);
  
  static TextStyle bigTitle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 64, fontWeight: FontWeight.bold);
  
  static TextStyle recipesGtitleStyle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 28, fontWeight: FontWeight.bold);

  static TextStyle semiBoldStyle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 26, fontWeight: FontWeight.bold);
  
  static TextStyle semiBoldStyle2() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 18, fontWeight: FontWeight.bold);

  // INICIO DE LA APLICACION
  static TextStyle centerTitle() => const TextStyle(color: Colors.white, fontFamily: "Poppins",fontSize: 58, fontWeight: FontWeight.bold);

}