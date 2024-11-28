import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/Background.png"), fit: BoxFit.cover)),
    );
  }
}

class StartBackgroundImage extends StatelessWidget {
  const StartBackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/startBackground.png"), fit: BoxFit.cover)),
    );
  }
}
