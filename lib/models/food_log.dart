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

  FoodLog({
    required this.id,
    required this.date,
    required this.foodName,
    required this.quantity,
    required this.hadReaction,
    this.reactionNotes = '',
  });
}
