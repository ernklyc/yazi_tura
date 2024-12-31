import 'dart:async';
import 'dart:math';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class FlipCoin extends StatefulWidget {
  final Function(String)? onResult;
  final bool shouldFlip;

  const FlipCoin({
    super.key,
    this.onResult,
    this.shouldFlip = false,
  });

  @override
  State<FlipCoin> createState() => _FlipCoinState();
}

class _FlipCoinState extends State<FlipCoin> {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  bool _isFrontSide = true;
  Timer? _flipTimer;
  final _random = Random();

  @override
  void didUpdateWidget(FlipCoin oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldFlip && oldWidget.shouldFlip != widget.shouldFlip) {
      _startFlipping();
    }
  }

  void _startFlipping() {
    int flipCount = 0;
    _flipTimer?.cancel();
    _flipTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (mounted) {
        setState(() {
          _isFrontSide = !_isFrontSide;
        });
        cardKey.currentState?.toggleCard();
        flipCount++;

        if (flipCount >= 10) {
          timer.cancel();
          final result = _random.nextBool() ? 'YAZI' : 'TURA';
          widget.onResult?.call(result);
        }
      }
    });
  }

  @override
  void dispose() {
    _flipTimer?.cancel();
    super.dispose();
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
