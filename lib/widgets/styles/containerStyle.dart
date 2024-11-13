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

  
  static BoxDecoration buttonContainerDec() {
    return BoxDecoration(
      color: Color(0xFFFF8330),
      borderRadius: BorderRadius.all(Radius.circular(32)),
    );
  }
}