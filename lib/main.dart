import 'dart:async';
import 'dart:math';
import './app_styles.dart';
import './app_colors.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SafeArea(
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String millisecondsText = '';
  GameState gameState = GameState.readyToStart;
  Timer? waitingTimer;
  Timer? stoppableTimer;
  Color buttonColor = Colors.black12;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double topPadding = screenSize.height * 0.1;
    final double bottomPadding = topPadding;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: const Align(
              alignment: Alignment(0, -0.9),
              child: Text(
                "Test your \nreaction speed!",
                textAlign: TextAlign.center,
                style: AppStyles.titleTextStyle,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ColoredBox(
              color: AppColors.boxColor,
              child: SizedBox(
                height: 160,
                width: 300,
                child: Center(
                  child: Text(
                    millisecondsText,
                    style: AppStyles.resultBoxTextStyle,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Align(
              alignment: const Alignment(0, 0.9),
              child: GestureDetector(
                onTap: () => setState(() {
                  switch (gameState) {
                    case (GameState.readyToStart):
                      gameState = GameState.waiting;
                      buttonColor = AppColors.waitButtonColor;
                      millisecondsText = '';
                      _startWaitingTimer();
                      break;
                    case (GameState.waiting):
                      buttonColor = AppColors.stopButtonColor;
                      break;
                    case (GameState.canBeStopped):
                      gameState = GameState.readyToStart;
                      buttonColor = AppColors.startButtonColor;
                      stoppableTimer?.cancel();
                      break;
                  }
                }),
                child: ColoredBox(
                  color: buttonColor,
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Text(
                        _getButtonText(),
                        style: AppStyles.buttonTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return "Start";
      case GameState.waiting:
        return "Wait";
      case GameState.canBeStopped:
        return "Stop";
    }
  }

  void _startWaitingTimer() {
    final int randomMilliseconds = Random().nextInt(4000) + 1000;
    waitingTimer = Timer(
      Duration(milliseconds: randomMilliseconds),
      () {
        setState(() {
          gameState = GameState.canBeStopped;
          _startStoppableTimer();
        });
      },
    );
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = "${timer.tick * 16} ms";
      });
    });
  }
}

enum GameState { readyToStart, waiting, canBeStopped }
