// import 'dart:collection';
import 'package:flutter/material.dart';

const textSize = 44.0;
const squareSize = 46.0;
const fontSize = 22.0;

void main() {
  runApp(const Game());
}

class Square extends StatelessWidget {
  const Square({
    Key? key,
    required this.onTap,
    required this.value,
  }) : super(key: key);

  final void Function() onTap;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: squareSize,
        width: squareSize,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(9, 9, 9, 1),
          ),
        ),
        child: Center(
          child: Text(
            value ?? '',
            style: const TextStyle(
              fontSize: textSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class Board extends StatefulWidget {
  const Board({
    Key? key,
  }) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<String?> _squares = List.generate(9, (index) => null);
  bool _xIsNext = true;

  void handleClick(int i) {
    final squares = _squares.sublist(0);
    if (calculateWinner(squares) != null || squares[i] != null) {
      return;
    }

    squares[i] = _xIsNext ? 'X' : 'O';
    setState(() {
      _squares = squares;
      _xIsNext = !_xIsNext;
    });
  }

  void handleReset() {
    final squares = _squares.sublist(0);
    for (var i = 0; i < squares.length; i++) {
      squares[i] = null;
    }

    setState(() {
      _squares = squares;
      _xIsNext = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final winner = calculateWinner(_squares);
    String status;
    if (winner == ' ') {
      status = 'Draw!';
    } else if (winner != null) {
      status = 'Winner: $winner';
    } else {
      status = 'Next player: ${_xIsNext ? 'X' : 'O'}';
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(6), // マージン
          child: Text(
            status,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
        SizedBox(
          height: squareSize * 3,
          width: squareSize * 3,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: List.generate(
              9,
              (int i) => Square(
                onTap: () => handleClick(i),
                value: _squares[i],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6), // マージン
          child:
            TextButton(
              onPressed: handleReset,
              style: TextButton.styleFrom(
                side: const BorderSide(
                  width: 2,
                  color: Colors.black54, //枠線の色
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
                foregroundColor: Colors.black, // foreground
                alignment: Alignment.topCenter,
              ),
              child: const Text('Restart'),
            ),
        ),
      ],
    );
  }
}

class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TicTacToe'),
          backgroundColor: const Color.fromARGB(255, 64, 86, 194),
        ),
        backgroundColor: const Color.fromARGB(255, 158, 162, 163),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Board(),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? calculateWinner(List<String?> squares) {
  const lines = [
    // 横
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    // 縦
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    // 斜め
    [0, 4, 8], [2, 4, 6],
  ];

  for (final positions in lines) {
    final cells = {
      squares[positions[0]],
      squares[positions[1]],
      squares[positions[2]]
    };
    if (cells.length == 1 && cells.first != null) {
      return cells.first;
    }
  }

  for (final v in squares) {
    if (v == null) {
      return null;
    }
  }
  return ' '; // draw
}
