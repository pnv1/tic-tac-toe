# Implementation Notes

## Project Overview
This is a Flutter Web application that implements a feature-rich Tic-Tac-Toe game with AI opponent, multiple board sizes, and advanced gameplay features. The application is configured for deployment to GitHub Pages.

## Project Structure

```
tic-tac-toe/
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions workflow for deployment
├── lib/
│   ├── main.dart               # Main application and UI
│   ├── game_state.dart         # Game state and logic (separated from UI)
│   ├── game_ai.dart            # AI opponent with difficulty levels
│   └── animated_board_cell.dart # Animated cell widget
├── test/
│   └── game_state_test.dart    # Unit tests for game logic
├── web/
│   ├── icons/
│   │   ├── Icon-192.png       # App icon (192x192)
│   │   └── Icon-512.png       # App icon (512x512)
│   ├── index.html             # Entry HTML file
│   ├── manifest.json          # Web app manifest
│   └── favicon.png            # Browser favicon
├── .gitignore                 # Git ignore rules for Flutter projects
├── .metadata                  # Flutter project metadata
├── analysis_options.yaml      # Dart/Flutter linting configuration
├── pubspec.yaml               # Flutter dependencies and project config
└── README.md                  # User documentation
```

## Architecture

### Separation of Concerns
The application follows a clean architecture pattern:

1. **Game Logic (`game_state.dart`)**:
   - `GameState` class manages all game state and logic
   - Supports variable board sizes (3×3, 10×10, etc.)
   - Configurable win conditions (e.g., 5 in a row for 10×10)
   - Tracks move history for undo functionality
   - Maintains scores across game series
   - No UI dependencies - pure business logic

2. **AI Logic (`game_ai.dart`)**:
   - `GameAI` class implements computer opponent
   - Three difficulty levels:
     - Easy: Random valid moves
     - Medium: Blocks opponent wins and tries to win
     - Hard: Minimax algorithm with alpha-beta pruning for 3×3, heuristic for larger boards
   - Separated from game state for modularity

3. **UI Components (`main.dart`, `animated_board_cell.dart`)**:
   - Responsive Flutter widgets
   - Settings screen for game configuration
   - Animated board cells with scale and rotation effects
   - Score display and game controls

### Key Features Implementation

1. **Variable Board Sizes**:
   - `GameState` accepts `boardSize` and `winCondition` parameters
   - Win detection algorithms work for any board size
   - UI automatically adjusts cell size based on board dimensions

2. **Win Detection**:
   - For standard boards (3×3): Checks all rows, columns, and diagonals
   - For larger boards with partial win conditions: Checks all possible sequences
   - Returns winning cell indices for highlighting

3. **Undo Functionality**:
   - Saves board state before each move in history
   - Can undo multiple moves
   - In PvC mode, undos both player and AI moves

4. **Score Tracking**:
   - Maintains separate scores for X, O, and draws
   - Scores persist across game resets (unless explicitly cleared)

5. **AI Difficulty Levels**:
   - Easy: Random move selection
   - Medium: Basic strategy (win if possible, block opponent)
   - Hard: Minimax for 3×3 (optimal play), advanced heuristics for larger boards

6. **Animations**:
   - Custom `AnimatedBoardCell` widget
   - Scale and rotation animations on symbol placement
   - Smooth transitions for winning cells
   - Visual feedback with shadows and gradients

## GitHub Pages Deployment

The `.github/workflows/deploy.yml` workflow:

1. Triggers on push to `main` branch or manual dispatch
2. Sets up Flutter SDK (version 3.24.5)
3. Installs dependencies with `flutter pub get`
4. Builds the web app with `flutter build web --release --base-href /tic-tac-toe/`
5. Uploads build artifacts to GitHub Pages
6. Deploys to GitHub Pages environment

**Important**: The `--base-href /tic-tac-toe/` flag is crucial for subpath hosting on GitHub Pages.

## Local Development

To run locally:
```bash
flutter pub get
flutter run -d chrome
```

To build for production:
```bash
flutter build web --release --base-href /tic-tac-toe/
```

## Dependencies

- Flutter SDK 3.0.0+
- flutter_lints for code quality
- No external packages required (uses only flutter/material)

## Testing

The project can be tested by:
1. Running locally with `flutter run -d chrome`
2. Playing through complete game scenarios
3. Testing win conditions (rows, columns, diagonals)
4. Testing draw condition
5. Testing reset functionality

The GitHub Actions workflow will automatically build and deploy when merged to main.
