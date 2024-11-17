import 'package:flutter/material.dart';

//les dejo una guia de como se declaran los colores 
//hexadecimales en dart
const Color _customColor = Color( 0xFFC11D9F );


//TODO: Agregar la paleta de colores de la aplicacion
const List<Color> _colorThemes =[
  _customColor,
  Colors.grey,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.yellow,
  Colors.white,
  Colors.pink,
  Colors.deepOrange,
];


class AppTheme {
  
  final int selectedColor;

  AppTheme({
    this.selectedColor = 0
  }):assert( selectedColor >= 0 && selectedColor <= _colorThemes.length -1 ,'Colors must be beetween 0 and ${_colorThemes.length - 1}' );

  ThemeData theme(){
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorThemes[selectedColor],
      // brightness: Brightness.dark
    );
  }
}