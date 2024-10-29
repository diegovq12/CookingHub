import 'package:cooking_hub/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yes NO App',
      debugShowCheckedModeBanner: false,
      theme:AppTheme(selectedColor: 7).theme(),
      // home: const ChatScreen()
      );
  }
}
