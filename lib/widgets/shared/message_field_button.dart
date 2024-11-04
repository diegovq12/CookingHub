import 'package:flutter/material.dart';

class MessageFieldButton extends StatelessWidget {
  final IconData icon;

  const MessageFieldButton({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.orange, // Background color
          shape: BoxShape.circle, // Circular shape
        ),
        child: IconButton(
          onPressed: () {},
          iconSize: 35,
          icon: Icon(icon),
        ),
      ),
    );
  }
}
