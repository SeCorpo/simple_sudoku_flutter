class CellModel {
  final int row;
  final int col;
  bool isFilled = false;
  final bool isCorrect;

  CellModel({
    required this.row,
    required this.col,
    required this.isCorrect,
  });

  /// **Toggle between empty and filled**
  void toggle() {
    isFilled = !isFilled;
  }

  /// **Convert to JSON (Only Saves Solution State)**
  Map<String, dynamic> toJson() => {
    'row': row,
    'col': col,
    'isCorrect': isCorrect,
  };

  /// **Load CellModel from JSON (Resets User Selections)**
  factory CellModel.fromJson(Map<String, dynamic> json) => CellModel(
    row: json['row'],
    col: json['col'],
    isCorrect: json['isCorrect'],
  );
}
