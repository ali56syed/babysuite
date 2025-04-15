import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/food_log.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register the FoodLogAdapter
  Hive.registerAdapter(FoodLogAdapter());

  // Open the Hive box
  await Hive.openBox<FoodLog>('food_logs');

  runApp(MyApp());  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Food Log',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
