import 'package:flutter/material.dart';

class ContainerStyle {
  static BoxDecoration topContainerDec() {
    return BoxDecoration(
      color: Color(0xFFFFA832),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      )
    );
  }
  
  static BoxDecoration genContainerDec() {
    return BoxDecoration(
      color: Color(0xFFFFA832),
      borderRadius: BorderRadius.all(Radius.circular(32)),
    );
  }
  
  static BoxDecoration bottomContainerDec() {
    return BoxDecoration(
      color: Color(0xFFFFA832),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
        ),
    );
  }

  
  static BoxDecoration buttonContainerDec() {
    return BoxDecoration(
      color: Color(0xFFFF8330),
      borderRadius: BorderRadius.all(Radius.circular(32)),
    );
  }
  
  static BoxDecoration button2ContainerDec() {
    return BoxDecoration(
      color: Color(0xFFFFCC33),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    );
  }

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