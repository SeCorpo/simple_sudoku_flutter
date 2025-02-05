
class CellModel {
  int row;
  int col;
  bool isFilled;
  bool isMarked;
  bool isCorrect; // If this cell should be filled based on the solution

  CellModel({
    required this.row,
    required this.col,
    this.isFilled = false,
    this.isMarked = false,
    this.isCorrect = false,
  });

  // Toggle cell state (filled -> empty -> marked)
  void toggle() {
    if (isFilled) {
      isFilled = false;
      isMarked = true;
    } else if (isMarked) {
      isMarked = false;
    } else {
      isFilled = true;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'row': row,
      'col': col,
      'isFilled': isFilled,
      'isMarked': isMarked,
      'isCorrect': isCorrect,
    };
  }

  factory CellModel.fromJson(Map<String, dynamic> json) {
    return CellModel(
      row: json['row'],
      col: json['col'],
      isFilled: json['isFilled'] ?? false,
      isMarked: json['isMarked'] ?? false,
      isCorrect: json['isCorrect'] ?? false,
    );
  }
}
