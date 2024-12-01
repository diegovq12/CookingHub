import 'package:flutter/material.dart';

class InputStyle {
  
  static InputDecoration inputDecoration(String placeHolder) {
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