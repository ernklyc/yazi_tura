import 'dart:async';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class FlipCoin extends StatefulWidget {
  const FlipCoin({super.key});

  @override
  State<FlipCoin> createState() => _FlipCoinState();
}

class _FlipCoinState extends State<FlipCoin> {
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
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: FlipCard(
        key: cardKey,
        front: const Image(image: AssetImage("assets/image/tura.jpeg")),
        back: const Image(image: AssetImage("assets/image/yazi.jpeg")),
        flipOnTouch: false,
        direction: FlipDirection.HORIZONTAL,
        speed: 500,
        onFlipDone: (isFrontSide) {
          setState(() {
            _isFrontSide = isFrontSide;
          });
        },
      ),
    );
  }
}
