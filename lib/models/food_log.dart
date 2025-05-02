class FoodLog {
  final String id;
  final DateTime date;
  final String foodName;
  final int quantity;
  final bool hadReaction;
  final String reactionNotes;
  final String? imagePath; // Optional field

  FoodLog({
    required this.id,
    required this.date,
    required this.foodName,
    required this.quantity,
    required this.hadReaction,
    required this.reactionNotes,
    this.imagePath,
  });

  // Convert FoodLog to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id.toString(),
      'date': date.toIso8601String(), // Convert DateTime to ISO 8601 string
      'foodName': foodName.toString(),
      'quantity': quantity.toString(),
      'hadReaction': hadReaction.toString(),
      'reactionNotes': reactionNotes.toString(),
      'imagePath': imagePath.toString(),
    };
  }

  // Create a FoodLog from Map<String, dynamic>
  factory FoodLog.fromMap(Map<String, dynamic> map) {
    return FoodLog(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String), // Parse ISO 8601 string to DateTime
      foodName: map['foodName'] as String,
      quantity: int.parse(map['quantity'] as String),
      hadReaction: bool.parse(map['hadReaction'] as String),
      reactionNotes: map['reactionNotes'] as String,
      imagePath: map['imagePath'] as String?,
    );
  }
}
