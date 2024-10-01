import 'package:flutter/material.dart';
import 'package:games/src/tictactoe/tictactoe.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var board = TicTacToeBoard();

  @override
  void initState() {
    super.initState();

    // ticker
  }

  @override
  Widget build(BuildContext context) {
    Widget? getWidget(int x, int y) {
      final player = board.grid[x][y];
      if (player == null) {
        return SizedBox.shrink();
      }

      return Icon(
        player == Player.o ? Icons.circle : Icons.close,
        size: 100,
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              height: 400,
              width: 400,
              child: Column(
                children: [
                  for (int x = 0; x < 3; x++)
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Row(
                          children: [
                            for (int y = 0; y < 3; y++)
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  if (board.canMark(x, y)) {
                                    setState(() {
                                      board.mark(x, y);
                                    });
                                  }
                                },
                                child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                                                      color: Colors.white,

                                  ),
                                  child: getWidget(x, y),
                                ),
                              ))
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
          Text(
            "Player ${board.currentPlayer}",
            style: TextStyle(fontSize: 50),
          ),
          if (board.isOver)
            Positioned.fill(
                child: Container(
              width: double.infinity,
              height: double.infinity,
              color: board.gameStatus is Draw ? Colors.red : Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    board.gameStatus is Win
                        ? "Player ${(board.gameStatus as Win).player} Won 🎉🎉🎉"
                        : "Game Draw",
                    style: TextStyle(fontSize: 50),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton.icon(onPressed: (){
                    setState(() {
                      board = TicTacToeBoard();
                    });
                  }, label: Text("Restart"))
                ],
              ),
            ))
        ],
      ),
    );
  }
}
