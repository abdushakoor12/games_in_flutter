import 'package:flutter_test/flutter_test.dart';
import 'package:games/src/tictactoe/tictactoe.dart';

void main() {
  group('Tic Tac Toe Tests', () {
    test("Board grid should be of null elements when initialized", () {
      final board = TicTacToeBoard();
      expect(board.grid.every((row) => row.every((element) => element == null)),
          true);
    });

    test("First turn should be of Player x", () {
      final board = TicTacToeBoard();
      expect(board.currentPlayer, equals(Player.x));
    });

    test("Initial player can be changed to Player o", () {
      final board = TicTacToeBoard(initialPlayer: Player.o);
      expect(board.currentPlayer, equals(Player.o));
    });

    test("Player x can mark a cell", () {
      final board = TicTacToeBoard();
      board.mark(0, 0);
      expect(board.grid[0][0], equals(Player.x));
    });

    test("invalid row and column should throw an error", () {
      final board = TicTacToeBoard();
      expect(() => board.mark(3, 3), throwsA(isA<AssertionError>()));
    });

    test("Current player changes when a cell is marked", () {
      const initialPlayer = Player.x;
      final board = TicTacToeBoard(initialPlayer: initialPlayer);
      board.mark(0, 0);
      expect(board.currentPlayer, equals(Player.o));
    });

    test("A cell can be marked only once", () {
      final board = TicTacToeBoard();
      board.mark(0, 0);
      expect(() => board.mark(0, 0), throwsA(isA<AssertionError>()));
    });

    test("test canMark method", () {
      final board = TicTacToeBoard();
      board.mark(0, 0);
      expect(board.canMark(0, 0), false);
      expect(board.canMark(0, 1), true);

      // test for invalid row and column
      expect(() => board.canMark(3, 3), throwsA(isA<AssertionError>()));
    });

    test("Game status changes from InProgress when all cells are marked", () {
      // emulate a draw
      final board = TicTacToeBoard()
        ..mark(0, 0)
        ..mark(1, 0)
        ..mark(2, 0)
        ..mark(0, 1)
        ..mark(1, 1)
        ..mark(2, 1)
        ..mark(0, 2)
        ..mark(1, 2)
        ..mark(2, 2);

      expect(board.gameStatus, isNot(equals(const InProgress())));
    });

    test(
      "Game status changes from InProgress to Win when a player wins",
      () {
        // emulate a draw
        final board = TicTacToeBoard()
          ..mark(1, 1) // player x in the middle
          ..mark(0, 0) // player o in the top left corner
          ..mark(2, 1) // player x in the middle bottom
          ..mark(2, 0); // player o in the bottom left corner

        expect(board.gameStatus, equals(const InProgress()));
        board.mark(0, 1); // player x in the middle top (to win)

        expect(board.gameStatus, equals(const Win(Player.x)));
      },
    );

    test(
      "Game status changes from InProgress to Draw when a player draws",
      () {
        /// o,x,o
        /// o,x,x
        /// x,o,x
        final board = TicTacToeBoard()
          ..mark(1, 1)
          ..mark(2, 1)
          ..mark(0, 1)
          ..mark(1, 0)
          ..mark(1, 2)
          ..mark(0, 0)
          ..mark(2, 0)
          ..mark(0, 2);

        expect(board.gameStatus, equals(const InProgress()));

        board.mark(2, 2);
        board.pringGrid();

        expect(board.gameStatus, equals(const Draw()));
      },
    );

    test(
      "Listeners are being added and removed",
      () {
        final board = TicTacToeBoard();
        void listener() {}
        board.addListener(listener);
        expect(board.listeners.contains(listener), true);
        board.removeListener(listener);
        expect(board.listeners.contains(listener), false);
      },
    );

    test(
      "Listeners are being notified when a cell is marked",
      () {
        int callCount = 0;
        final board = TicTacToeBoard();
        listener() {
          callCount++;
        }
        board.addListener(listener);
        board.mark(0, 0);
        expect(callCount, 1);
      },
    );
  });
}
