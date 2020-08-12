import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<String> _blocks = List.generate(9, (_) => '');
  Random _rand = Random();
  bool _isPlayerOne;
  int _p1Points = 0;
  int _p2Points = 0;

  @override
  void initState() {
    super.initState();
    _isPlayerOne = _rand.nextBool();
  }

  int handleTap(int index) {
    setState(() {
      _blocks[index] = _isPlayerOne ? 'X' : 'O';
      _isPlayerOne = !_isPlayerOne;
    });

    return checkWin(index);
  }

  int checkWin(int index) {
    int _firstCol = index - (index % 3);
    // TODO: (AAYAN) recheck when bren is working
    int _firstRow = (index - (index % 9)) + (index % 3);

    if (checkRow('X', _firstCol) || checkCol('X', _firstRow) || checkDiag('X'))
      return 1;
    else if (checkRow('O', _firstCol) ||
        checkCol('O', _firstRow) ||
        checkDiag('O')) return -1;

    return 0;
  }

  bool checkRow(String letter, int firstCol) {
    return _blocks[firstCol] == letter &&
        _blocks[firstCol + 1] == letter &&
        _blocks[firstCol + 2] == letter;
  }

  bool checkCol(String letter, int firstRow) {
    return _blocks[firstRow] == letter &&
        _blocks[firstRow + 3] == letter &&
        _blocks[firstRow + 6] == letter;
  }

  bool checkDiag(String letter) {
    // Small, but is an optimization nonetheless
    if (_blocks[4] != letter) return false;
    return (_blocks[0] == letter && _blocks[8] == letter) ||
        (_blocks[2] == letter && _blocks[6] == letter);
  }

  void reset() {
    setState(() {
      _isPlayerOne = _rand.nextBool();
      _blocks = List.generate(9, (_) => '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) => Container(
            constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * 0.7,
                maxHeight: constraints.maxHeight * 0.9),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(_isPlayerOne ? "P1's turn" : "P2's turn",
                    style: Theme.of(context).textTheme.headline6),
                for (int i = 0; i < 3; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int j = 0; j < 3; j++)
                        GestureDetector(
                            onTap: () {
                              int didWin = handleTap(i + j + (i * 2));

                              if (didWin != 0) {
                                reset();
                                if (didWin == 1) {
                                  _p1Points++;
                                  showDialog(
                                      context: context,
                                      barrierColor: Colors.greenAccent
                                          .withOpacity(0.54),
                                      barrierDismissible: true,
                                      builder: (context) => AlertDialog(
                                            title: Text('Game Over'),
                                            content: Text('Player one wins'),
                                          ));
                                }

                                if (didWin == -1) {
                                  _p2Points++;
                                  showDialog(
                                      context: context,
                                      barrierColor:
                                          Colors.redAccent.withOpacity(0.54),
                                      barrierDismissible: true,
                                      builder: (context) => AlertDialog(
                                            title: Text('Game Over'),
                                            content: Text('Player two wins'),
                                          ));
                                }
                              }
                            },
                            child: Container(
                              height: min(constraints.maxHeight,
                                      constraints.maxWidth) *
                                  0.5 /
                                  3,
                              width: min(constraints.maxHeight,
                                      constraints.maxWidth) *
                                  0.5 /
                                  3,
                              decoration: BoxDecoration(border: Border.all()),
                              alignment: Alignment.center,
                              child: Text(_blocks[i + j + (i * 2)],
                                  style: TextStyle(fontSize: 20)),
                            ))
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('P1: $_p1Points',
                        style: TextStyle(fontSize: 20)),
                    FlatButton(onPressed: reset, child: Text('Reset')),
                    Text('P2: $_p2Points',
                        style: TextStyle(fontSize: 20))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
