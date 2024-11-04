import 'package:flutter/material.dart';

class HotBar extends StatelessWidget {
  const HotBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        // constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width),
        decoration: const BoxDecoration(
            color: Color.fromRGBO(255, 170, 50, 1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.home_outlined)),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.sports_esports_outlined)),
            Positioned(
                child: IconButton(
                    onPressed: () {},
                    icon: Image.asset("assets/HotBar/Gorrito.png", width: 50))
            ),
            IconButton(onPressed: (){}, icon: const Icon(Icons.list)),
            IconButton(onPressed: (){}, icon: const Icon(Icons.person_2_outlined)),
            
          ],
        ),
      ),
    );
  }
}
