import 'package:cooking_hub/domain/entities/message.dart';
import 'package:flutter/material.dart';

class GtpMessageBubble extends StatelessWidget {
  final Message message;

  const GtpMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    const borderRadius = BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20));

                    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: borderRadius),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                message.text,
                style: const TextStyle(color: Colors.black),
              ),
            )),
        const SizedBox(height: 10),
      ],
    );
  }
}
