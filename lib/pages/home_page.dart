import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/app_bar_button_link.dart';
import '../core/counter.dart';
import '../core/flip_card.dart';
import '../core/win_page.dart';
import '../product/color/color_items.dart';
import '../product/lang/langue_item.dart';
import '../product/utils/constants.dart';
import 'dart:ui';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  String? player1Choice;
  String? player2Choice;
  bool player1Ready = false;
  bool player2Ready = false;
  int player1Score = 0;
  int player2Score = 0;
  bool isFlipping = false;

  // Renk paleti
  final Color primaryColor = const Color.fromARGB(255, 156, 0, 0);                       // İndigo - Hazır butonu
  final Color accentColor = const Color(0xFF22C55E);                       // Yeşil - Seçili durum
  final Color backgroundColor = const Color.fromARGB(255, 38, 38, 38);     // Arka plan
  final Color textColor = Colors.white;                                    // Metinler
  final Color buttonColor = const Color(0xFF27272A);                      // Koyu gri - Butonlar
  final Color borderColor = const Color.fromARGB(255, 70, 70, 70);        // Çizgiler
  
  late AnimationController _scoreController;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scoreAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  void _resetGame() {
    setState(() {
      player1Choice = null;
      player2Choice = null;
      player1Ready = false;
      player2Ready = false;
      isFlipping = false;
    });
  }

  void _checkWinner(String result) {
    if (player1Choice == result) {
      setState(() => player1Score++);
      _scoreController.forward(from: 0);
    } else if (player2Choice == result) {
      setState(() => player2Score++);
      _scoreController.forward(from: 0);
    }
    Future.delayed(const Duration(seconds: 2), _resetGame);
  }

  void _checkBothReady() {
    if (player1Ready && player2Ready && !isFlipping) {
      setState(() => isFlipping = true);
    }
  }

  Widget _buildChoiceButton(String choice, bool isSelected, VoidCallback onPressed) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? accentColor : Colors.white24,
                width: 1.5,
              ),
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? accentColor.withOpacity(0.2) : buttonColor,
                foregroundColor: textColor,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    choice == 'HEADS' ? FontAwesomeIcons.one : FontAwesomeIcons.userLarge,
                    size: 32,
                    color: isSelected ? accentColor : textColor,
                  ),
                  SizedBox(height: 4),
                  Text(
                    choice,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      letterSpacing: 0.5,
                      color: isSelected ? accentColor : textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayerSection(
    String playerName,
    int score,
    String? choice,
    bool isReady,
    Function(String) onChoiceSelected,
    VoidCallback onReadyPressed,
    bool isRotated,
  ) {
    return Container(
      color: backgroundColor,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: RotatedBox(
          quarterTurns: isRotated ? 2 : 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                playerName,
                style: TextStyle(
                  color: textColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              ScaleTransition(
                scale: _scoreAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: buttonColor.withOpacity(0.3), width: 1),
                  ),
                  child: Text(
                    'SCORE: $score',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              if (!isReady) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildChoiceButton(
                      'HEADS',
                      choice == 'YAZI',
                      () => onChoiceSelected('YAZI'),
                    ),
                    const SizedBox(width: 20),
                    _buildChoiceButton(
                      'TAILS',
                      choice == 'TURA',
                      () => onChoiceSelected('TURA'),
                    ),
                  ],
                ),
                if (choice != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: 140,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: onReadyPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isReady ? FontAwesomeIcons.check : FontAwesomeIcons.xmark,
                            size: 16,
                            color: backgroundColor,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'READY',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: backgroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ] else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: accentColor, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isReady ? FontAwesomeIcons.check : FontAwesomeIcons.xmark,
                        color: accentColor,
                        size: 16
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'READY!',
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildPlayerSection(
                'PLAYER 1',
                player1Score,
                player1Choice,
                player1Ready,
                (choice) => setState(() => player1Choice = choice),
                () {
                  setState(() => player1Ready = true);
                  _checkBothReady();
                },
                true,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border(
                  top: BorderSide(color: borderColor, width: 1),
                  bottom: BorderSide(color: borderColor, width: 1),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.25,
              child: Center(
                child: FlipCoin(
                  onResult: (String result) {
                    if (isFlipping) {
                      _checkWinner(result);
                    }
                  },
                  shouldFlip: isFlipping,
                ),
              ),
            ),
            Expanded(
              child: _buildPlayerSection(
                'PLAYER 2',
                player2Score,
                player2Choice,
                player2Ready,
                (choice) => setState(() => player2Choice = choice),
                () {
                  setState(() => player2Ready = true);
                  _checkBothReady();
                },
                false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
