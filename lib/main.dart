import 'package:flutter/material.dart';
import 'package:yazi_tura/product/color/color_items.dart';
import 'core/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yazı Tura',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: ProjectColor().elevatedButton,
          elevation: 0,
        ),
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
