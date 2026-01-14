# Tic-Tac-Toe

A simple Tic-Tac-Toe game built with Flutter Web and deployed to GitHub Pages.

## Features

- Two-player game (X and O)
- Win detection (rows, columns, diagonals)
- Draw detection
- Reset game functionality
- Responsive design

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
