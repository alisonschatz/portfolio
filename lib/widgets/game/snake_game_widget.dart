import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/direction.dart';

class SnakeGameWidget extends StatefulWidget {
  const SnakeGameWidget({super.key});

  @override
  State<SnakeGameWidget> createState() => _SnakeGameWidgetState();
}

class _SnakeGameWidgetState extends State<SnakeGameWidget> {
  static const int rows = 25;
  static const int columns = 20;
  static const double cellSize = 15;
  static const double gameWidth = columns * cellSize;
  static const double gameHeight = rows * cellSize;
  static const double minTotalWidth = 500;

  List<Point<int>> snake = [const Point(10, 10)];
  Point<int> food = const Point(5, 5);
  Direction direction = Direction.right;
  Timer? gameTimer;
  bool isPlaying = false;
  int foodCollected = 0;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    snake = [const Point(10, 10)];
    direction = Direction.right;
    _generateFood();
    foodCollected = 0;
  }

  void _generateFood() {
    final random = Random();
    do {
      food = Point(random.nextInt(columns), random.nextInt(rows));
    } while (snake.contains(food));
  }

  void _startGame() {
    if (gameTimer != null) return;
    
    setState(() => isPlaying = true);
    gameTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _updateGame();
    });
    _focusNode.requestFocus();
  }

  void _updateGame() {
    setState(() {
      // Calculate new head position
      Point<int> newHead;
      switch (direction) {
        case Direction.up:
          newHead = Point(snake.first.x, (snake.first.y - 1 + rows) % rows);
          break;
        case Direction.down:
          newHead = Point(snake.first.x, (snake.first.y + 1) % rows);
          break;
        case Direction.left:
          newHead = Point((snake.first.x - 1 + columns) % columns, snake.first.y);
          break;
        case Direction.right:
          newHead = Point((snake.first.x + 1) % columns, snake.first.y);
          break;
      }

      // Check for collisions with self
      if (snake.contains(newHead)) {
        _gameOver();
        return;
      }

      // Move snake
      snake.insert(0, newHead);
      
      // Check for food
      if (newHead == food) {
        foodCollected++;
        if (foodCollected >= 10) {
          _gameWon();
          return;
        }
        _generateFood();
      } else {
        snake.removeLast();
      }
    });
  }

  void _gameOver() {
    gameTimer?.cancel();
    gameTimer = null;
    setState(() {
      isPlaying = false;
    });
    _showGameDialog('Game Over', 'Try again?');
  }

  void _gameWon() {
    gameTimer?.cancel();
    gameTimer = null;
    setState(() {
      isPlaying = false;
    });
    _showGameDialog('Congratulations!', 'You won! Play again?');
  }

  void _showGameDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF001524),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _initGame();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.tealAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      setState(() {
        switch (event.logicalKey.keyLabel) {
          case 'Arrow Up':
            if (direction != Direction.down) direction = Direction.up;
            break;
          case 'Arrow Down':
            if (direction != Direction.up) direction = Direction.down;
            break;
          case 'Arrow Left':
            if (direction != Direction.right) direction = Direction.left;
            break;
          case 'Arrow Right':
            if (direction != Direction.left) direction = Direction.right;
            break;
        }
      });
    }
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed, double size, double iconSize) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.tealAccent.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: iconSize),
        onPressed: isPlaying ? onPressed : null,
        color: Colors.tealAccent,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildGameControls() {
    const double buttonSize = 40;
    const double iconSize = 24;
    
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '// controls',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 15),
          _buildControlButton(Icons.arrow_upward, () {
            if (direction != Direction.down) direction = Direction.up;
          }, buttonSize, iconSize),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(Icons.arrow_back, () {
                if (direction != Direction.right) direction = Direction.left;
              }, buttonSize, iconSize),
              SizedBox(width: buttonSize * 0.5),
              _buildControlButton(Icons.arrow_forward, () {
                if (direction != Direction.left) direction = Direction.right;
              }, buttonSize, iconSize),
            ],
          ),
          _buildControlButton(Icons.arrow_downward, () {
            if (direction != Direction.up) direction = Direction.down;
          }, buttonSize, iconSize),
          const SizedBox(height: 20),
          const Text(
            '// progress',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              10,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: index < foodCollected 
                    ? Colors.tealAccent 
                    : Colors.teal.withOpacity(0.2),
                  shape: BoxShape.circle,
                  boxShadow: index < foodCollected ? [
                    BoxShadow(
                      color: Colors.tealAccent.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ] : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: buttonSize * 2,
            child: ElevatedButton(
              onPressed: isPlaying ? null : _startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBackgroundColor: Colors.tealAccent.withOpacity(0.3),
              ),
              child: Text(
                isPlaying ? 'playing...' : 'start-game',
                style: TextStyle(
                  color: isPlaying ? Colors.white54 : Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: minTotalWidth,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game Area
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Score Display
                Container(
                  width: gameWidth,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.amber.withOpacity(0.7), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Score: $foodCollected',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Game Board
                Container(
                  width: gameWidth,
                  height: gameHeight,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.tealAccent.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        // Grid lines
                        ...List.generate(rows + 1, (index) => Positioned(
                          left: 0,
                          top: index * cellSize,
                          child: Container(
                            width: columns * cellSize,
                            height: 0.5,
                            color: Colors.teal.withOpacity(0.1),
                          ),
                        )),
                        ...List.generate(columns + 1, (index) => Positioned(
                          left: index * cellSize,
                          top: 0,
                          child: Container(
                            width: 0.5,
                            height: rows * cellSize,
                            color: Colors.teal.withOpacity(0.1),
                          ),
                        )),
                        // Food with glow effect
                        Positioned(
                          left: food.x * cellSize,
                          top: food.y * cellSize,
                          child: Container(
                            width: cellSize,
                            height: cellSize,
                            decoration: BoxDecoration(
                              color: Colors.tealAccent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.tealAccent.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Snake with gradient effect
                        ...snake.map((point) => Positioned(
                          left: point.x * cellSize,
                          top: point.y * cellSize,
                          child: Container(
                            width: cellSize,
                            height: cellSize,
                            decoration: BoxDecoration(
                              color: point == snake.first 
                                ? Colors.tealAccent 
                                : Colors.teal.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: point == snake.first ? [
                                BoxShadow(
                                  color: Colors.tealAccent.withOpacity(0.3),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ] : null,
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Controls Area
            const SizedBox(width: 20),
            _buildGameControls(),
          ],
        ),
      ),
    );
  }
}