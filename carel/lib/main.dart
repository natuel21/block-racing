import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(CarRacingGame());
}

class CarRacingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'blockel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double carPositionX = 0;
  double carPositionY = 0.8;
  double carWidth = 0.2;
  double carHeight = 0.1;
  double obstaclePositionX = 0;
  double obstaclePositionY = -0.2;
  double obstacleWidth = 0.2;
  double obstacleHeight = 0.1;
  bool gameRunning = false;
  Timer? gameTimer;
  int score = 0;

  void startGame() {
    gameRunning = true;
    score = 0;
    obstaclePositionY = -0.2;
    gameTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        obstaclePositionY += 0.02;
        if (obstaclePositionY > 1) {
          obstaclePositionY = -0.2;
          obstaclePositionX = Random().nextDouble() * (1 - obstacleWidth);
          score++;
        }
        if (isCollision()) {
          timer.cancel();
          gameRunning = false;
          showGameOverDialog();
        }
      });
    });
  }

  void moveLeft() {
    if (carPositionX > 0) {
      setState(() {
        carPositionX -= 0.1;
      });
    }
  }

  void moveRight() {
    if (carPositionX < 1 - carWidth) {
      setState(() {
        carPositionX += 0.1;
      });
    }
  }

  bool isCollision() {
    return (obstaclePositionY + obstacleHeight > carPositionY) &&
        (obstaclePositionX < carPositionX + carWidth) &&
        (obstaclePositionX + obstacleWidth > carPositionX);
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text(
              'Your score: $score ,                              \By Natuel'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color(0xff181818),
          ),
          Positioned(
            left: carPositionX * MediaQuery.of(context).size.width,
            top: carPositionY * MediaQuery.of(context).size.height,
            child: Container(
              width: carWidth * MediaQuery.of(context).size.width,
              height: carHeight * MediaQuery.of(context).size.height,
              color: Colors.blue,
            ),
          ),
          Positioned(
            left: obstaclePositionX * MediaQuery.of(context).size.width,
            top: obstaclePositionY * MediaQuery.of(context).size.height,
            child: Container(
              width: obstacleWidth * MediaQuery.of(context).size.width,
              height: obstacleHeight * MediaQuery.of(context).size.height,
              color: Colors.red,
            ),
          ),
          if (!gameRunning)
            Center(
              child: ElevatedButton(
                onPressed: startGame,
                child: Text('Start Game'),
              ),
            ),
          Positioned(
            top: 40,
            left: 20,
            child: Text(
              'Score: $score',
              style: TextStyle(fontSize: 20, color: Color(0xff08abec)),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: moveLeft,
            child: Icon(Icons.arrow_left),
          ),
          FloatingActionButton(
            onPressed: moveRight,
            child: Icon(Icons.arrow_right),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
