import 'package:cooking_hub/config/theme/app_theme.dart';
import 'package:cooking_hub/presentation/providers/chat_provider.dart';
import 'package:cooking_hub/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatProvider())
      ],
      child: MaterialApp(
        title: 'Cooking Hub',
        debugShowCheckedModeBanner: false,
        theme:AppTheme(selectedColor: 0).theme(),
        home: const ChatScreen()
        ),
    );
    return MaterialApp(
      title: 'Yes NO App',
      debugShowCheckedModeBanner: false,
      theme:AppTheme(selectedColor: 7).theme(),
      // home: const ChatScreen()
      );

  }
}
