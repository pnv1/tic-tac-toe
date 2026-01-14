import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/game_state.dart';

void main() {
  group('GameState 3x3 Tests', () {
    test('Initial state is correct', () {
      final game = GameState();
      expect(game.boardSize, 3);
      expect(game.board.length, 9);
      expect(game.isXTurn, true);
      expect(game.gameOver, false);
      expect(game.winner, '');
    });

    test('Make valid move', () {
      final game = GameState();
      final result = game.makeMove(0);
      expect(result, true);
      expect(game.board[0], 'X');
      expect(game.isXTurn, false);
    });

    test('Prevent move on occupied cell', () {
      final game = GameState();
      game.makeMove(0);
      final result = game.makeMove(0);
      expect(result, false);
      expect(game.board[0], 'X');
    });

    test('Detect row win', () {
      final game = GameState();
      game.makeMove(0); // X
      game.makeMove(3); // O
      game.makeMove(1); // X
      game.makeMove(4); // O
      game.makeMove(2); // X wins

      expect(game.gameOver, true);
      expect(game.winner, 'X');
      expect(game.winningCombination, [0, 1, 2]);
      expect(game.xScore, 1);
    });

    test('Detect column win', () {
      final game = GameState();
      game.makeMove(0); // X
      game.makeMove(1); // O
      game.makeMove(3); // X
      game.makeMove(4); // O
      game.makeMove(6); // X wins

      expect(game.gameOver, true);
      expect(game.winner, 'X');
      expect(game.winningCombination, [0, 3, 6]);
    });

    test('Detect diagonal win', () {
      final game = GameState();
      game.makeMove(0); // X
      game.makeMove(1); // O
      game.makeMove(4); // X
      game.makeMove(2); // O
      game.makeMove(8); // X wins

      expect(game.gameOver, true);
      expect(game.winner, 'X');
      expect(game.winningCombination, [0, 4, 8]);
    });

    test('Detect anti-diagonal win', () {
      final game = GameState();
      game.makeMove(2); // X
      game.makeMove(0); // O
      game.makeMove(4); // X
      game.makeMove(1); // O
      game.makeMove(6); // X wins

      expect(game.gameOver, true);
      expect(game.winner, 'X');
      expect(game.winningCombination, [2, 4, 6]);
    });

    test('Detect draw', () {
      final game = GameState();
      // X O X
      // O O X
      // X X O
      game.makeMove(0); // X
      game.makeMove(1); // O
      game.makeMove(2); // X
      game.makeMove(4); // O
      game.makeMove(3); // X
      game.makeMove(6); // O
      game.makeMove(5); // X
      game.makeMove(8); // O
      game.makeMove(7); // X

      expect(game.gameOver, true);
      expect(game.winner, 'Draw');
      expect(game.drawScore, 1);
    });

    test('Undo move', () {
      final game = GameState();
      game.makeMove(0); // X
      game.makeMove(1); // O
      
      final undoResult = game.undoMove();
      expect(undoResult, true);
      expect(game.board[1], '');
      expect(game.isXTurn, false);
      
      game.undoMove();
      expect(game.board[0], '');
      expect(game.isXTurn, true);
    });

    test('Cannot undo when no moves made', () {
      final game = GameState();
      final result = game.undoMove();
      expect(result, false);
    });

    test('Reset game keeps scores', () {
      final game = GameState();
      game.makeMove(0); // X
      game.makeMove(3); // O
      game.makeMove(1); // X
      game.makeMove(4); // O
      game.makeMove(2); // X wins
      
      expect(game.xScore, 1);
      
      game.reset(keepScores: true);
      expect(game.board.every((cell) => cell == ''), true);
      expect(game.gameOver, false);
      expect(game.xScore, 1);
    });

    test('Reset game clears scores', () {
      final game = GameState();
      game.makeMove(0); // X
      game.makeMove(3); // O
      game.makeMove(1); // X
      game.makeMove(4); // O
      game.makeMove(2); // X wins
      
      game.reset(keepScores: false);
      expect(game.xScore, 0);
    });

    test('Set first player', () {
      final game = GameState();
      game.setFirstPlayer(false);
      expect(game.isXTurn, false);
      expect(game.currentPlayer, 'O');
    });

    test('Prevent moves after game over', () {
      final game = GameState();
      game.makeMove(0); // X
      game.makeMove(3); // O
      game.makeMove(1); // X
      game.makeMove(4); // O
      game.makeMove(2); // X wins

      final result = game.makeMove(5);
      expect(result, false);
    });
  });

  group('GameState 10x10 Tests', () {
    test('Create 10x10 board with 5 in a row win condition', () {
      final game = GameState(boardSize: 10, winCondition: 5);
      expect(game.boardSize, 10);
      expect(game.board.length, 100);
      expect(game.winCondition, 5);
    });

    test('Detect horizontal 5 in a row', () {
      final game = GameState(boardSize: 10, winCondition: 5);
      // Place 5 X's in a row
      for (int i = 0; i < 5; i++) {
        game.makeMove(i); // X
        if (i < 4) game.makeMove(10 + i); // O (different row)
      }

      expect(game.gameOver, true);
      expect(game.winner, 'X');
      expect(game.winningCombination, [0, 1, 2, 3, 4]);
    });

    test('Detect vertical 5 in a row', () {
      final game = GameState(boardSize: 10, winCondition: 5);
      // Place 5 X's in a column
      for (int i = 0; i < 5; i++) {
        game.makeMove(i * 10); // X at column 0
        if (i < 4) game.makeMove(i * 10 + 1); // O at column 1
      }

      expect(game.gameOver, true);
      expect(game.winner, 'X');
      expect(game.winningCombination, [0, 10, 20, 30, 40]);
    });

    test('Detect diagonal 5 in a row', () {
      final game = GameState(boardSize: 10, winCondition: 5);
      // Place 5 X's diagonally
      for (int i = 0; i < 5; i++) {
        game.makeMove(i * 11); // X at diagonal
        if (i < 4) game.makeMove(i * 10 + 5); // O elsewhere
      }

      expect(game.gameOver, true);
      expect(game.winner, 'X');
      expect(game.winningCombination, [0, 11, 22, 33, 44]);
    });
  });

  group('GameState Helper Methods', () {
    test('isWinningCell returns true for winning cells', () {
      final game = GameState();
      game.makeMove(0); // X
      game.makeMove(3); // O
      game.makeMove(1); // X
      game.makeMove(4); // O
      game.makeMove(2); // X wins

      expect(game.isWinningCell(0), true);
      expect(game.isWinningCell(1), true);
      expect(game.isWinningCell(2), true);
      expect(game.isWinningCell(3), false);
    });

    test('currentPlayer returns correct symbol', () {
      final game = GameState();
      expect(game.currentPlayer, 'X');
      game.makeMove(0);
      expect(game.currentPlayer, 'O');
    });
  });
}
