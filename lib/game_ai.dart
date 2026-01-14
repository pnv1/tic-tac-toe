import 'dart:math';
import 'game_state.dart';

/// AI opponent for Tic-Tac-Toe game
class GameAI {
  final Random _random = Random();
  final String aiSymbol;

  GameAI({this.aiSymbol = 'O'});

  /// Get best move based on difficulty level
  int getBestMove(GameState game, String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return _getRandomMove(game);
      case 'medium':
        return _getMediumMove(game);
      case 'hard':
        return _getHardMove(game);
      default:
        return _getRandomMove(game);
    }
  }

  /// Easy: Random move
  int _getRandomMove(GameState game) {
    final availableMoves = _getAvailableMoves(game);
    if (availableMoves.isEmpty) return -1;
    return availableMoves[_random.nextInt(availableMoves.length)];
  }

  /// Medium: Block opponent's winning move or random
  int _getMediumMove(GameState game) {
    // First try to win
    final winningMove = _findWinningMove(game, aiSymbol);
    if (winningMove != -1) return winningMove;

    // Then try to block opponent
    final opponentSymbol = aiSymbol == 'X' ? 'O' : 'X';
    final blockingMove = _findWinningMove(game, opponentSymbol);
    if (blockingMove != -1) return blockingMove;

    // Otherwise random move
    return _getRandomMove(game);
  }

  /// Hard: Minimax algorithm with alpha-beta pruning
  int _getHardMove(GameState game) {
    // For larger boards, use heuristic approach
    if (game.boardSize > 3) {
      return _getLargeBoardMove(game);
    }

    // For 3x3 board, use minimax
    int bestScore = -1000;
    int bestMove = -1;
    final opponentSymbol = aiSymbol == 'X' ? 'O' : 'X';

    for (int i = 0; i < game.board.length; i++) {
      if (game.board[i] == '') {
        // Try move
        game.board[i] = aiSymbol;
        int score = _minimax(game, 0, false, opponentSymbol, -1000, 1000);
        game.board[i] = '';

        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }

    return bestMove != -1 ? bestMove : _getRandomMove(game);
  }

  /// Minimax algorithm with alpha-beta pruning
  int _minimax(GameState game, int depth, bool isMaximizing, String opponentSymbol, int alpha, int beta) {
    // Check terminal states
    if (game.gameOver) {
      if (game.winner == aiSymbol) return 10 - depth;
      if (game.winner == opponentSymbol) return depth - 10;
      return 0; // Draw
    }

    // Depth limit for performance
    if (depth > 6) return 0;

    if (isMaximizing) {
      int maxScore = -1000;
      for (int i = 0; i < game.board.length; i++) {
        if (game.board[i] == '') {
          game.board[i] = aiSymbol;
          final currentGameOver = game.gameOver;
          final currentWinner = game.winner;
          game._checkWinner();
          
          int score = _minimax(game, depth + 1, false, opponentSymbol, alpha, beta);
          
          game.board[i] = '';
          game.gameOver = currentGameOver;
          game.winner = currentWinner;
          game.winningCombination = null;
          
          maxScore = max(score, maxScore);
          alpha = max(alpha, score);
          if (beta <= alpha) break;
        }
      }
      return maxScore;
    } else {
      int minScore = 1000;
      for (int i = 0; i < game.board.length; i++) {
        if (game.board[i] == '') {
          game.board[i] = opponentSymbol;
          final currentGameOver = game.gameOver;
          final currentWinner = game.winner;
          game._checkWinner();
          
          int score = _minimax(game, depth + 1, true, opponentSymbol, alpha, beta);
          
          game.board[i] = '';
          game.gameOver = currentGameOver;
          game.winner = currentWinner;
          game.winningCombination = null;
          
          minScore = min(score, minScore);
          beta = min(beta, score);
          if (beta <= alpha) break;
        }
      }
      return minScore;
    }
  }

  /// Heuristic approach for larger boards
  int _getLargeBoardMove(GameState game) {
    final opponentSymbol = aiSymbol == 'X' ? 'O' : 'X';

    // 1. Try to win
    final winningMove = _findWinningMove(game, aiSymbol);
    if (winningMove != -1) return winningMove;

    // 2. Block opponent's winning move
    final blockingMove = _findWinningMove(game, opponentSymbol);
    if (blockingMove != -1) return blockingMove;

    // 3. Try to create threats (multiple potential winning sequences)
    final threatMove = _findThreatMove(game, aiSymbol);
    if (threatMove != -1) return threatMove;

    // 4. Block opponent's threats
    final blockThreatMove = _findThreatMove(game, opponentSymbol);
    if (blockThreatMove != -1) return blockThreatMove;

    // 5. Take strategic positions (center, corners, edges)
    final strategicMove = _findStrategicMove(game);
    if (strategicMove != -1) return strategicMove;

    // 6. Random move as fallback
    return _getRandomMove(game);
  }

  /// Find a winning move for the given symbol
  int _findWinningMove(GameState game, String symbol) {
    for (int i = 0; i < game.board.length; i++) {
      if (game.board[i] == '') {
        game.board[i] = symbol;
        final currentGameOver = game.gameOver;
        final currentWinner = game.winner;
        game._checkWinner();
        
        final isWin = game.gameOver && game.winner == symbol;
        
        game.board[i] = '';
        game.gameOver = currentGameOver;
        game.winner = currentWinner;
        game.winningCombination = null;
        
        if (isWin) return i;
      }
    }
    return -1;
  }

  /// Find a move that creates multiple winning threats
  int _findThreatMove(GameState game, String symbol) {
    int bestMove = -1;
    int maxThreats = 0;

    for (int i = 0; i < game.board.length; i++) {
      if (game.board[i] == '') {
        game.board[i] = symbol;
        int threats = _countPotentialWins(game, symbol);
        game.board[i] = '';

        if (threats > maxThreats) {
          maxThreats = threats;
          bestMove = i;
        }
      }
    }

    return maxThreats >= 2 ? bestMove : -1;
  }

  /// Count potential winning sequences
  int _countPotentialWins(GameState game, String symbol) {
    int count = 0;
    final winCondition = game.winCondition;
    
    // Check all possible sequences
    for (int row = 0; row < game.boardSize; row++) {
      for (int col = 0; col <= game.boardSize - winCondition; col++) {
        if (_isPotentialWin(game, symbol, List.generate(winCondition, (i) => row * game.boardSize + col + i))) {
          count++;
        }
      }
    }

    for (int col = 0; col < game.boardSize; col++) {
      for (int row = 0; row <= game.boardSize - winCondition; row++) {
        if (_isPotentialWin(game, symbol, List.generate(winCondition, (i) => (row + i) * game.boardSize + col))) {
          count++;
        }
      }
    }

    return count;
  }

  /// Check if a sequence is a potential win
  bool _isPotentialWin(GameState game, String symbol, List<int> indices) {
    int symbolCount = 0;
    int emptyCount = 0;

    for (int index in indices) {
      if (game.board[index] == symbol) {
        symbolCount++;
      } else if (game.board[index] == '') {
        emptyCount++;
      } else {
        return false; // Opponent has a piece here
      }
    }

    return symbolCount >= game.winCondition - 1 && emptyCount > 0;
  }

  /// Find strategic position (center, corners, etc.)
  int _findStrategicMove(GameState game) {
    final size = game.boardSize;
    
    // For 3x3, prefer center, then corners, then edges
    if (size == 3) {
      if (game.board[4] == '') return 4; // Center
      final corners = [0, 2, 6, 8];
      for (int corner in corners) {
        if (game.board[corner] == '') return corner;
      }
    } else {
      // For larger boards, prefer center area
      final center = size ~/ 2;
      final centerIndices = [
        center * size + center,
        center * size + center - 1,
        center * size + center + 1,
        (center - 1) * size + center,
        (center + 1) * size + center,
      ];
      
      for (int index in centerIndices) {
        if (index >= 0 && index < game.board.length && game.board[index] == '') {
          return index;
        }
      }
    }

    return -1;
  }

  /// Get list of available moves
  List<int> _getAvailableMoves(GameState game) {
    List<int> moves = [];
    for (int i = 0; i < game.board.length; i++) {
      if (game.board[i] == '') {
        moves.add(i);
      }
    }
    return moves;
  }
}
