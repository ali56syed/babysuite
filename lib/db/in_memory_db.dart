import '../models/food_log.dart';

class InMemoryDB {
  static final InMemoryDB _instance = InMemoryDB._internal();
  final List<FoodLog> _foodLogs = [];

  InMemoryDB._internal();

  static InMemoryDB get instance => _instance;

  List<FoodLog> get foodLogs => _foodLogs;

  void addFoodLog(FoodLog foodLog) {
    _foodLogs.add(foodLog);
  }
}