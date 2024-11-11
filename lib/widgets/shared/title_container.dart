import 'package:flutter/material.dart';

class TitleContainer extends StatelessWidget {
  final String title;

  const TitleContainer({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    

    return Container(
      // decoration: const BoxDecoration(
      //   // color: Color.fromRGBO(255, 168, 50, 1),
      //   borderRadius: BorderRadius.all(Radius.circular(16)),
      //   // boxShadow: [
      //   //   BoxShadow(
      //   //     color: Color.fromARGB(120, 0, 0, 0),
      //   //     spreadRadius: 0,
      //   //     blurRadius: 5,
      //   //     offset: Offset(0, 3),
      //   //   ),
      //   // ],
      // ),
      margin: EdgeInsets.only(
        top: screenHeight * 0.01, // Ajustar el margen superior para moverlo más arriba
        left: screenWidth * 0.03,
        right: screenWidth * 0.03,
      ),
      height: screenHeight * 0.1,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth*0.12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
