import 'package:cooking_hub/domain/entities/message.dart';
import 'package:flutter/material.dart';

class GtpMessageBubble extends StatelessWidget {
  final Message message;

  const GtpMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            constraints: BoxConstraints(maxWidth: 250),
            decoration: BoxDecoration(
                color: colors.secondary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                message.text,
                style: const TextStyle(color: Colors.white),
              ),
            )),
        const SizedBox(height: 10),
      ],
    );
  }
}
