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
    return const MaterialApp(
      home: MyHomePage(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        const Align(
          alignment: Alignment(0, -0.9),
          child: Text(
            "Test your \nreaction speed!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ColoredBox(
            color: Colors.black26,
            child: SizedBox(
              height: 160,
              width: 300,
              child: Center(
                child: Text(
                  millisecondsText,
                  style: const TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, 0.9),
          child: GestureDetector(
            onTap: () => setState(() {
              switch (gameState) {
                case (GameState.readyToStart):
                  gameState = GameState.waiting;
                  millisecondsText = '';
                  _startWaitingTimer();
                  break;
                case (GameState.waiting):
                  break;
                case (GameState.canBeStopped):
                  gameState = GameState.readyToStart;
                  stoppableTimer?.cancel();
                  break;
              }
            }),
            child: ColoredBox(
              color: Colors.black12,
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
