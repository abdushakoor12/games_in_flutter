class TicTacToeBoard {
  final List<Function> _listeners = [];
  
  /// should only be used for testing
  List<Function> get listeners => _listeners;

  final List<List<Player?>> _grid;

  GameStatus _gameStatus = const InProgress();
  GameStatus get gameStatus => _gameStatus;

  TicTacToeBoard({
    Player initialPlayer = Player.x,
  })  : _grid = List.generate(
            3, (_) => List.generate(3, (__) => null, growable: false),
            growable: false),
        _currentPlayer = initialPlayer;

  late Player _currentPlayer;
  Player get currentPlayer => _currentPlayer;

  List<List<Player?>> get grid => _grid;

  bool get isDraw => gameStatus is Draw;

  bool get isOver => gameStatus is Draw || gameStatus is Win;

  void mark(int row, int column) {
    assert(row >= 0 && row < 3);
    assert(column >= 0 && column < 3);

    assert(_grid[row][column] == null);

    _grid[row][column] = currentPlayer;
    _currentPlayer = currentPlayer == Player.x ? Player.o : Player.x;

    // check for winner
    final winner = getWinner();
    if (winner != null) {
      _gameStatus = Win(winner);
      return;
    }

    if (_grid.every((row) => row.every((element) => element != null))) {
      _gameStatus = const Draw();
    }

    _notify();
  }

  void _notify() => _listeners.forEach((fn) => fn());

  Player? getWinner() {
    // forward diagonal
    if (_grid[0][0] == _grid[1][1] &&
        _grid[1][1] == _grid[2][2] &&
        _grid[0][0] != null) {
      return _grid[0][0]!;
    }

    // backward diagonal
    if (_grid[0][2] == _grid[1][1] &&
        _grid[1][1] == _grid[2][0] &&
        _grid[0][2] != null) {
      return _grid[0][2]!;
    }

    // all horizontals
    if (_grid[0][0] == _grid[0][1] &&
        _grid[0][1] == _grid[0][2] &&
        _grid[0][0] != null) {
      return _grid[0][0]!;
    }

    if (_grid[1][0] == _grid[1][1] &&
        _grid[1][1] == _grid[1][2] &&
        _grid[1][0] != null) {
      return _grid[1][0]!;
    }

    if (_grid[2][0] == _grid[2][1] &&
        _grid[2][1] == _grid[2][2] &&
        _grid[2][0] != null) {
      return _grid[2][0]!;
    }

    // all verticals
    if (_grid[0][0] == _grid[1][0] &&
        _grid[1][0] == _grid[2][0] &&
        _grid[0][0] != null) {
      return _grid[0][0]!;
    }

    if (_grid[0][1] == _grid[1][1] &&
        _grid[1][1] == _grid[2][1] &&
        _grid[0][1] != null) {
      return _grid[0][1]!;
    }

    if (_grid[0][2] == _grid[1][2] &&
        _grid[1][2] == _grid[2][2] &&
        _grid[0][2] != null) {
      return _grid[0][2]!;
    }

    return null;
  }

  bool canMark(int row, int column) {
    assert(row >= 0 && row < 3);
    assert(column >= 0 && column < 3);

    return _grid[row][column] == null;
  }

  void addListener(Function listener) {
    _listeners.add(listener);
  }

  void removeListener(Function listener) {
    _listeners.remove(listener);
  }

  void pringGrid() {
    print("****");
    for (var row in _grid) {
      print(row.map((e) => e ?? "-").join("|"));
    }
    print("****");
  }
}

enum Player {
  x,
  o;

  @override
  String toString() {
    return this == Player.x ? "X" : "O";
  }
}

sealed class GameStatus {
  const GameStatus();
}

class InProgress extends GameStatus {
  const InProgress();
}

class Draw extends GameStatus {
  const Draw();
}

class Win extends GameStatus {
  final Player player;
  const Win(this.player);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Win && other.player == player;
  }

  @override
  int get hashCode => player.hashCode;
}
