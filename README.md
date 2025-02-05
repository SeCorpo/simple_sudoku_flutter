A structured project folder layout for Nonogram Flutter game. It follows best practices and keeps everything modular and scalable.

Models (models/)

    PuzzleModel: Represents the nonogram puzzle.
    CellModel: Defines the state of each cell (filled, empty, marked).

🔹 Providers (providers/)

    GameProvider: Manages puzzle state and logic.
    TimerProvider: Tracks time for a challenge mode.

🔹 Services (services/)

    PuzzleService: Loads puzzles from JSON or generates them.
    SaveService: Saves game progress locally.

🔹 UI (ui/)

    game_grid.dart: Renders the interactive nonogram grid.
    clue_numbers.dart: Displays clues for rows/columns.
    cell_widget.dart: Manages cell interaction (tap for fill/empty/X).
    controls_widget.dart: Buttons for actions like reset, undo, hint.

🔹 Data (data/)

    puzzles.json: Stores pre-made puzzles.
    user_progress.json: Saves user’s puzzle progress.



### Component Tree
simple_sudoku_flutter/

│── lib/                  # Main application code  
│   ├── main.dart         # Entry point of the app  
│   ├── app.dart          # App root widget  
│   │  
│   ├── core/             # Core utilities and global helpers  
│   │   ├── constants.dart     # Game constants (colors, grid size)  
│   │   ├── theme.dart         # Theme data  
│   │   ├── utils.dart         # Utility functions  
│   │  
│   ├── models/           # Data models  
│   │   ├── puzzle_model.dart  # Represents a Nonogram puzzle  
│   │   ├── cell_model.dart    # Represents a single cell state  
│   │  
│   ├── providers/        # State management (Provider/Riverpod)  
│   │   ├── game_provider.dart  # Game logic and state  
│   │   ├── timer_provider.dart # Optional: For a timer feature  
│   │  
│   ├── services/         # Game logic and services  
│   │   ├── puzzle_service.dart  # Loads and validates puzzles  
│   │   ├── save_service.dart    # Saves progress locally (Hive/Sqflite)  
│   │  
│   ├── ui/               # UI components and screens  
│   │   ├── screens/  
│   │   │   ├── home_screen.dart     # Main menu  
│   │   │   ├── game_screen.dart     # Puzzle game screen  
│   │   │   ├── settings_screen.dart # Settings page  
│   │   │   ├── leaderboard_screen.dart # Optional: Scores & Progress  
│   │   │  
│   │   ├── widgets/  
│   │   │   ├── game_grid.dart       # Renders the puzzle grid  
│   │   │   ├── clue_numbers.dart    # Displays row/column clues  
│   │   │   ├── cell_widget.dart     # Single cell UI  
│   │   │   ├── timer_widget.dart    # Optional: Timer display  
│   │   │   ├── controls_widget.dart # Undo, Reset, Hints  
│   │  
│   ├── data/             # Store local puzzle files (JSON)  
│   │   ├── puzzles.json       # Predefined puzzles  
│   │   ├── user_progress.json  # Saves user progress  
│── pubspec.yaml         # Dependencies (Flutter SDK, packages)  
│── README.md            # Project documentation  
│── assets/              # Images, fonts, sounds  
│   ├── fonts/  
│   ├── images/  
│   ├── sounds/  
│── test/                # Unit and widget tests  
│   ├── game_test.dart  
│   ├── ui_test.dart  
