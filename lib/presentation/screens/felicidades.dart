import 'package:cooking_hub/presentation/screens/recetas.dart';
import 'package:cooking_hub/widgets/styles/textStyles.dart';
import 'package:flutter/material.dart';

class Congratulations extends StatefulWidget{
  const Congratulations({super.key});

  @override
  State<Congratulations> createState() => _CongratulationsState();
}

class _CongratulationsState extends State<Congratulations> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Recetas()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFA832),
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth*0.1,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("RECETA TERMINADA",style: Textstyles.titleStyle(),textAlign: TextAlign.center,),
                Text("Bien hecho",style: Textstyles.semiBoldStyle(),textAlign: TextAlign.center),
                Image.asset("assets/gif/cook.gif", width: screenHeight*0.2,)
              ],
            ),
          ),
        ),
      )
    );
    
  }
}