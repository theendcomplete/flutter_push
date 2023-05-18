import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    final Size screen_size = MediaQuery.of(context).size;
    final double top_padding = screen_size.height * 0.1;
    final double bottom_padding = top_padding;


    return Scaffold(
      backgroundColor: Color(0xFF282E3D),
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.only(top: top_padding),
          child: const Align(
            alignment: Alignment(0, -0.9),
            child: Text(
              "Test your \nreaction speed!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ColoredBox(
            color: Color(0xFF6D6D6D),
            child: SizedBox(
              height: 160,
              width: 300,
              child: Center(
                child: Text(
                  millisecondsText,
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: bottom_padding),
          child: Align(
            alignment: const Alignment(0, 0.9),
            child: GestureDetector(
              onTap: () => setState(() {
// Когда написано START — цвет кнопки должен быть FF40CA88
// Когда написано WAIT — цвет кнопки должен быть FFE0982D
// Когда написано STOP — цвет кнопки должен быть FFE02D47

                switch (gameState) {
                  case (GameState.readyToStart):
                    gameState = GameState.waiting;
                    buttonColor = const Color(0xFFE0982D);
                    millisecondsText = '';
                    _startWaitingTimer();
                    break;
                  case (GameState.waiting):
                    buttonColor = const Color(0xFFE02D47);
                    break;
                  case (GameState.canBeStopped):
                    gameState = GameState.readyToStart;
                    buttonColor = const Color(0xFF40CA88);
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
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
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
        Duration(
          milliseconds: randomMilliseconds,
        ), () {
      setState(() {
        gameState = GameState.canBeStopped;
        _startStoppableTimer();
      });
    });
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = "${timer.tick * 16} ms";
      });
    });
  }
}

enum GameState { readyToStart, waiting, canBeStopped }
