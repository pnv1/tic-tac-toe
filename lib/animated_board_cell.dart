import 'package:flutter/material.dart';

/// Animated cell for Tic-Tac-Toe board
class AnimatedBoardCell extends StatefulWidget {
  final String symbol;
  final bool isWinningCell;
  final bool gameOver;
  final VoidCallback onTap;
  final double fontSize;

  const AnimatedBoardCell({
    super.key,
    required this.symbol,
    required this.isWinningCell,
    required this.gameOver,
    required this.onTap,
    this.fontSize = 48,
  });

  @override
  State<AnimatedBoardCell> createState() => _AnimatedBoardCellState();
}

class _AnimatedBoardCellState extends State<AnimatedBoardCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  String _previousSymbol = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(AnimatedBoardCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.symbol != _previousSymbol && widget.symbol.isNotEmpty) {
      _controller.forward(from: 0);
    }
    _previousSymbol = widget.symbol;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: widget.isWinningCell
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green[300]!,
                    Colors.green[400]!,
                  ],
                )
              : null,
          color: widget.isWinningCell
              ? null
              : (widget.gameOver ? Colors.grey[300] : Colors.blue[100]),
          border: Border.all(
            color: widget.isWinningCell ? Colors.green[700]! : Colors.blue,
            width: widget.isWinningCell ? 3 : 2,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: widget.isWinningCell
              ? [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: widget.symbol.isEmpty
              ? const SizedBox.shrink()
              : ScaleTransition(
                  scale: _scaleAnimation,
                  child: RotationTransition(
                    turns: _rotationAnimation,
                    child: Text(
                      widget.symbol,
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.bold,
                        color: widget.symbol == 'X'
                            ? Colors.blue[900]
                            : Colors.red[900],
                        shadows: [
                          Shadow(
                            color: (widget.symbol == 'X'
                                    ? Colors.blue[900]
                                    : Colors.red[900])!
                                .withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
