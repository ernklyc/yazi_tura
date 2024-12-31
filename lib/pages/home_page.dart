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
  final Color primaryColor = const Color.fromARGB(255, 156, 0, 0);         // Kırmızı - Hazır butonu
  final Color accentColor = const Color(0xFF22C55E);                       // Yeşil - Seçili durum
  final Color backgroundColor = const Color.fromARGB(255, 38, 38, 38);     // Arka plan
  final Color textColor = Colors.white;                                    // Metinler
  final Color buttonColor = const Color(0xFF27272A);                      // Koyu gri - Butonlar
  final Color borderColor = const Color.fromARGB(255, 70, 70, 70);        // Çizgiler
  final Color winnerColor = const Color(0xFFFFD700);                      // Altın - Kazanan rengi

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
    String winner = '';
    if (player1Choice == result) {
      setState(() => player1Score++);
      winner = 'PLAYER 1';
      _scoreController.forward(from: 0);
    } else if (player2Choice == result) {
      setState(() => player2Score++);
      winner = 'PLAYER 2';
      _scoreController.forward(from: 0);
    }

    // Kazananı göster
    if (winner.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        builder: (BuildContext context) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: winnerColor, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: winnerColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    FontAwesomeIcons.crown,
                    color: winnerColor,
                    size: 45,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  winner,
                  style: TextStyle(
                    color: winnerColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'WINS!',
                  style: TextStyle(
                    color: winnerColor.withOpacity(0.9),
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // 2 saniye sonra dialogu kapat ve oyunu sıfırla
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop();
          _resetGame();
        }
      });
    }
  }

  void _checkBothReady() {
    if (player1Ready && player2Ready && !isFlipping) {
      setState(() => isFlipping = true);
    }
  }

  Widget _buildChoiceButton(String choice, bool isSelected, VoidCallback onPressed) {
    double buttonSize = MediaQuery.of(context).size.width * 0.2;
    buttonSize = buttonSize.clamp(60.0, 80.0); // Min 60, max 80

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: Container(
            width: buttonSize,
            height: buttonSize,
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
                    size: buttonSize * 0.4,
                    color: isSelected ? accentColor : textColor,
                  ),
                  SizedBox(height: buttonSize * 0.05),
                  Text(
                    choice,
                    style: TextStyle(
                      fontSize: buttonSize * 0.175,
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
        padding: const EdgeInsets.symmetric(vertical: 15),
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
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 20),
              if (!isReady) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildChoiceButton(
                      'HEADS',
                      choice == 'YAZI',
                      () => onChoiceSelected('YAZI'),
                    ),
                    const SizedBox(width: 16),
                    _buildChoiceButton(
                      'TAILS',
                      choice == 'TURA',
                      () => onChoiceSelected('TURA'),
                    ),
                  ],
                ),
                if (choice != null) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: onReadyPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                              letterSpacing: 1.2,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          letterSpacing: 1,
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
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            Expanded(flex: 2, child: _buildPlayerSection(
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
            )),
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border(
                  top: BorderSide(color: borderColor, width: 1),
                  bottom: BorderSide(color: borderColor, width: 1),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.35,
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
            Expanded(flex: 2, child: _buildPlayerSection(
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
            )),
          ],
        ),
      ),
    );
  }
}
