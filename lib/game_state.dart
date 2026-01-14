/// Represents the game state and logic for Tic-Tac-Toe
class GameState {
  final int boardSize;
  final int winCondition;
  List<String> board;
  bool isXTurn;
  String winner;
  bool gameOver;
  List<int>? winningCombination;
  int xScore;
  int oScore;
  int drawScore;
  List<List<String>> history; // For undo functionality

  GameState({
    this.boardSize = 3,
    int? winCondition,
  })  : board = List.filled(boardSize * boardSize, ''),
        isXTurn = true,
        winner = '',
        gameOver = false,
        winningCombination = null,
        xScore = 0,
        oScore = 0,
        drawScore = 0,
        history = [],
        winCondition = winCondition ?? boardSize;

  /// Make a move at the given index
  bool makeMove(int index) {
    if (board[index] != '' || gameOver) return false;

    // Save state for undo
    history.add(List.from(board));

    board[index] = isXTurn ? 'X' : 'O';
    isXTurn = !isXTurn;
    _checkWinner();
    return true;
  }

  /// Undo the last move
  bool undoMove() {
    if (history.isEmpty) return false;

    board = history.removeLast();
    isXTurn = !isXTurn;
    winner = '';
    gameOver = false;
    winningCombination = null;
    return true;
  }

  /// Check for a winner or draw
  void _checkWinner() {
    // Check rows
    for (int i = 0; i < boardSize; i++) {
      if (_checkLine(_getRow(i))) return;
    }

    // Check columns
    for (int i = 0; i < boardSize; i++) {
      if (_checkLine(_getColumn(i))) return;
    }

    // Check diagonals
    if (_checkLine(_getDiagonal1())) return;
    if (_checkLine(_getDiagonal2())) return;

    // For larger boards, check all possible winning sequences
    if (boardSize > 3) {
      if (_checkAllSequences()) return;
    }

    // Check for draw
    if (!board.contains('')) {
      winner = 'Draw';
      gameOver = true;
      drawScore++;
    }
  }

  /// Get row indices
  List<int> _getRow(int row) {
    return List.generate(boardSize, (col) => row * boardSize + col);
  }

  /// Get column indices
  List<int> _getColumn(int col) {
    return List.generate(boardSize, (row) => row * boardSize + col);
  }

  /// Get main diagonal indices
  List<int> _getDiagonal1() {
    return List.generate(boardSize, (i) => i * boardSize + i);
  }

  /// Get anti-diagonal indices
  List<int> _getDiagonal2() {
    return List.generate(boardSize, (i) => i * boardSize + (boardSize - 1 - i));
  }

  /// Check if a line has a winner
  bool _checkLine(List<int> indices) {
    if (indices.length < winCondition) return false;

    // For standard win condition (entire line)
    if (winCondition == boardSize) {
      final firstCell = board[indices[0]];
      if (firstCell == '') return false;

      for (int i = 1; i < indices.length; i++) {
        if (board[indices[i]] != firstCell) return false;
      }

      winner = firstCell;
      gameOver = true;
      winningCombination = indices;
      _updateScore();
      return true;
    }

    // For partial win condition (e.g., 5 in a row on 10x10)
    for (int start = 0; start <= indices.length - winCondition; start++) {
      final firstCell = board[indices[start]];
      if (firstCell == '') continue;

      bool hasWin = true;
      for (int i = 1; i < winCondition; i++) {
        if (board[indices[start + i]] != firstCell) {
          hasWin = false;
          break;
        }
      }

      if (hasWin) {
        winner = firstCell;
        gameOver = true;
        winningCombination = indices.sublist(start, start + winCondition);
        _updateScore();
        return true;
      }
    }

    return false;
  }

  /// Check all possible sequences for larger boards
  bool _checkAllSequences() {
    // Check horizontal sequences
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col <= boardSize - winCondition; col++) {
        final sequence = List.generate(
          winCondition,
          (i) => row * boardSize + col + i,
        );
        if (_checkSequence(sequence)) return true;
      }
    }

    // Check vertical sequences
    for (int col = 0; col < boardSize; col++) {
      for (int row = 0; row <= boardSize - winCondition; row++) {
        final sequence = List.generate(
          winCondition,
          (i) => (row + i) * boardSize + col,
        );
        if (_checkSequence(sequence)) return true;
      }
    }

    // Check diagonal sequences (top-left to bottom-right)
    for (int row = 0; row <= boardSize - winCondition; row++) {
      for (int col = 0; col <= boardSize - winCondition; col++) {
        final sequence = List.generate(
          winCondition,
          (i) => (row + i) * boardSize + (col + i),
        );
        if (_checkSequence(sequence)) return true;
      }
    }

    // Check anti-diagonal sequences (top-right to bottom-left)
    for (int row = 0; row <= boardSize - winCondition; row++) {
      for (int col = winCondition - 1; col < boardSize; col++) {
        final sequence = List.generate(
          winCondition,
          (i) => (row + i) * boardSize + (col - i),
        );
        if (_checkSequence(sequence)) return true;
      }
    }

    return false;
  }

  /// Check if a specific sequence is a winner
  bool _checkSequence(List<int> indices) {
    final firstCell = board[indices[0]];
    if (firstCell == '') return false;

    for (int i = 1; i < indices.length; i++) {
      if (board[indices[i]] != firstCell) return false;
    }

    winner = firstCell;
    gameOver = true;
    winningCombination = indices;
    _updateScore();
    return true;
  }

  /// Update score based on winner
  void _updateScore() {
    if (winner == 'X') {
      xScore++;
    } else if (winner == 'O') {
      oScore++;
    }
  }

  /// Reset the game but keep scores
  void reset({bool keepScores = true}) {
    board = List.filled(boardSize * boardSize, '');
    isXTurn = true;
    winner = '';
    gameOver = false;
    winningCombination = null;
    history = [];

    if (!keepScores) {
      xScore = 0;
      oScore = 0;
      drawScore = 0;
    }
  }

  /// Set who goes first
  void setFirstPlayer(bool xGoesFirst) {
    isXTurn = xGoesFirst;
  }

  /// Get current player symbol
  String get currentPlayer => isXTurn ? 'X' : 'O';

  /// Check if a cell is part of winning combination
  bool isWinningCell(int index) {
    return winningCombination?.contains(index) ?? false;
  }
}
