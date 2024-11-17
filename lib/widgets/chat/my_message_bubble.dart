import 'package:cooking_hub/domain/entities/message.dart';
import 'package:flutter/material.dart';

class MyMessageBubble extends StatelessWidget {
  
  final Message message;
  
  const MyMessageBubble({super.key,required this.message});


  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          decoration: const BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(20),
              bottomRight:  Radius.circular(20)
            )
          ),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(message.text, style: const TextStyle(color: Colors.black),)
          ),
        ),

        const SizedBox(height: 10),

      ],
    );
  }
}