import 'package:hive/hive.dart';

part 'food_log.g.dart';

@HiveType(typeId: 0)
class FoodLog {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String foodName;

  @HiveField(3)
  final String quantity;

  @HiveField(4)
  final bool hadReaction;

  @HiveField(5)
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
      'id': id,
      'date': date.toIso8601String(), // Convert DateTime to ISO 8601 string
      'foodName': foodName,
      'quantity': quantity,
      'hadReaction': hadReaction,
      'reactionNotes': reactionNotes,
      'imagePath': imagePath,
    };
  }

  // Create a FoodLog from Map<String, dynamic>
  factory FoodLog.fromMap(Map<String, dynamic> map) {
    return FoodLog(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String), // Parse ISO 8601 string to DateTime
      foodName: map['foodName'] as String,
      quantity: map['quantity'] as String,
      hadReaction: map['hadReaction'] as bool,
      reactionNotes: map['reactionNotes'] as String,
      imagePath: map['imagePath'] as String?,
    );
  }
}
