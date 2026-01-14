import 'package:flutter/material.dart';
import 'game_state.dart';
import 'game_ai.dart';
import 'animated_board_cell.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic-Tac-Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late GameState _gameState;
  late GameAI _gameAI;
  int _boardSize = 3;
  String _gameMode = 'pvp'; // 'pvp' or 'pvc'
  String _difficulty = 'medium';
  bool _showSettings = true;

  @override
  void initState() {
    super.initState();
    _gameState = GameState(boardSize: _boardSize);
    _gameAI = GameAI(aiSymbol: 'O');
  }

  void _handleTap(int index) async {
    if (!_gameState.makeMove(index)) return;

    setState(() {});

    // AI move if in PvC mode and game not over
    if (_gameMode == 'pvc' && !_gameState.gameOver && _gameState.currentPlayer == 'O') {
      await Future.delayed(const Duration(milliseconds: 600));
      final aiMove = _gameAI.getBestMove(_gameState, _difficulty);
      if (aiMove != -1) {
        _gameState.makeMove(aiMove);
        setState(() {});
      }
    }
  }

  void _resetGame() {
    setState(() {
      _gameState.reset(keepScores: true);
    });
  }

  void _newGame() {
    setState(() {
      _gameState = GameState(
        boardSize: _boardSize,
        winCondition: _boardSize == 10 ? 5 : _boardSize,
      );
      _gameAI = GameAI(aiSymbol: 'O');
      _showSettings = false;
    });
  }

  void _undoMove() {
    setState(() {
      // In PvC mode, undo twice to undo both player and AI moves
      if (_gameMode == 'pvc') {
        _gameState.undoMove();
      }
      _gameState.undoMove();
    });
  }

  void _showSettingsDialog() {
    setState(() {
      _showSettings = true;
    });
  }

  Widget _buildSettings() {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Game Settings',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text('Board Size:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    ChoiceChip(
                      label: const Text('3×3 (Classic)'),
                      selected: _boardSize == 3,
                      onSelected: (selected) {
                        setState(() {
                          _boardSize = 3;
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('10×10 (5 in a row)'),
                      selected: _boardSize == 10,
                      onSelected: (selected) {
                        setState(() {
                          _boardSize = 10;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Game Mode:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    ChoiceChip(
                      label: const Text('Player vs Player'),
                      selected: _gameMode == 'pvp',
                      onSelected: (selected) {
                        setState(() {
                          _gameMode = 'pvp';
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Player vs Computer'),
                      selected: _gameMode == 'pvc',
                      onSelected: (selected) {
                        setState(() {
                          _gameMode = 'pvc';
                        });
                      },
                    ),
                  ],
                ),
                if (_gameMode == 'pvc') ...[
                  const SizedBox(height: 20),
                  const Text('Difficulty:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      ChoiceChip(
                        label: const Text('Easy'),
                        selected: _difficulty == 'easy',
                        onSelected: (selected) {
                          setState(() {
                            _difficulty = 'easy';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Medium'),
                        selected: _difficulty == 'medium',
                        onSelected: (selected) {
                          setState(() {
                            _difficulty = 'medium';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Hard'),
                        selected: _difficulty == 'hard',
                        onSelected: (selected) {
                          setState(() {
                            _difficulty = 'hard';
                          });
                        },
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                const Text('First Player:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    ChoiceChip(
                      label: const Text('X goes first'),
                      selected: _gameState.isXTurn,
                      onSelected: (selected) {
                        setState(() {
                          _gameState.setFirstPlayer(true);
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('O goes first'),
                      selected: !_gameState.isXTurn,
                      onSelected: (selected) {
                        setState(() {
                          _gameState.setFirstPlayer(false);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _newGame,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      'Start Game',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showSettings) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tic-Tac-Toe'),
          centerTitle: true,
        ),
        body: _buildSettings(),
      );
    }

    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final boardWidth = isSmallScreen
        ? MediaQuery.of(context).size.width * 0.9
        : (_boardSize == 3 ? 300.0 : 500.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic-Tac-Toe'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Score display
              Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildScoreItem('X', _gameState.xScore, Colors.blue[900]!),
                      const SizedBox(width: 20),
                      _buildScoreItem('Draw', _gameState.drawScore, Colors.grey[700]!),
                      const SizedBox(width: 20),
                      _buildScoreItem('O', _gameState.oScore, Colors.red[900]!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Current player / Winner display
              Text(
                _gameState.gameOver
                    ? (_gameState.winner == 'Draw'
                        ? 'It\'s a Draw!'
                        : '${_gameState.winner} Wins! 🎉')
                    : 'Current Turn: ${_gameState.currentPlayer}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _gameState.gameOver
                      ? Colors.green[700]
                      : (_gameState.currentPlayer == 'X' ? Colors.blue[900] : Colors.red[900]),
                ),
              ),
              const SizedBox(height: 20),
              // Game board
              SizedBox(
                width: boardWidth,
                height: boardWidth,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _boardSize,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: _boardSize * _boardSize,
                  itemBuilder: (context, index) {
                    return AnimatedBoardCell(
                      symbol: _gameState.board[index],
                      isWinningCell: _gameState.isWinningCell(index),
                      gameOver: _gameState.gameOver,
                      onTap: () => _handleTap(index),
                      fontSize: _boardSize == 3 ? 48 : 24,
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              // Action buttons
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _gameState.history.isEmpty ? null : _undoMove,
                    icon: const Icon(Icons.undo),
                    label: const Text('Undo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _resetGame,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showSettingsDialog,
                    icon: const Icon(Icons.settings),
                    label: const Text('New Game'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreItem(String label, int score, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          score.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
