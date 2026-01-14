# Tic-Tac-Toe

A feature-rich Tic-Tac-Toe game built with Flutter Web and deployed to GitHub Pages.

## Features

### 🎮 Game Modes
- **Player vs Player** - Local two-player mode
- **Player vs Computer** - Play against AI opponent with three difficulty levels:
  - **Easy** - Random moves
  - **Medium** - Blocks obvious wins
  - **Hard** - Strategic play using minimax algorithm

### 🧩 Board Options
- **3×3 Classic** - Traditional Tic-Tac-Toe rules
- **10×10 Advanced** - Win with 5 symbols in a row

### ✨ Gameplay Features
- Current player indicator
- Winning combination highlighting with animations
- Score tracking across multiple games
- Undo last move
- Choose who goes first (X or O)
- Correct draw detection
- Field blocking after game ends

### 🖥️ UI/UX
- Responsive design (mobile-friendly)
- Visual differences between X and O (colors with shadows)
- Smooth symbol placement animations
- Score display for series of games
- Intuitive settings menu

### ⚙️ Architecture
- Separated game logic from UI
- Centralized game state management
- Support for variable board sizes
- Unit tests for core game logic
- AI opponent with multiple difficulty levels

## Play Online

The game is deployed at: https://pnv1.github.io/tic-tac-toe/

## Building Locally

### Prerequisites

- Flutter SDK (3.0.0 or higher)

### Steps

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run in development mode:
   ```bash
   flutter run -d chrome
   ```

3. Build for production:
   ```bash
   flutter build web --release --base-href /tic-tac-toe/
   ```

The built files will be in the `build/web` directory.

## Deployment

The project is automatically deployed to GitHub Pages using GitHub Actions whenever changes are pushed to the `main` branch.

### Manual Deployment

If you need to deploy manually:

1. Build the project:
   ```bash
   flutter build web --release --base-href /tic-tac-toe/
   ```

2. The `build/web` directory contains the deployable files.

### GitHub Actions Workflow

The deployment workflow (`.github/workflows/deploy.yml`) automatically:
- Checks out the code
- Sets up Flutter
- Installs dependencies
- Builds the web app with the correct base-href
- Deploys to GitHub Pages

No manual configuration or parameters are required.
