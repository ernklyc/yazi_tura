import 'dart:async';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import '../pages/home_page.dart';
import '../product/color/color_items.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  bool _isFrontSide = true;

  void _startFlipCardLoop() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _isFrontSide = !_isFrontSide;
        });
        cardKey.currentState!.toggleCard();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startFlipCardLoop();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: FlipCard(
                key: cardKey,
                front: const Image(
                    image: AssetImage("assets/image/ic_launcher.png")),
                back: const Image(
                    image: AssetImage("assets/image/ic_launcher.png")),
                flipOnTouch: false,
                direction: FlipDirection.VERTICAL,
                speed: 500,
                onFlipDone: (isFrontSide) {
                  setState(() {
                    _isFrontSide = isFrontSide;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      splashIconSize: 10000,
      centered: true,
      duration: 2000,
      backgroundColor: ProjectColor().bg,
      nextScreen: const MyHomePage(),
    );
  }
}
