import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/food_log.dart';
import 'screens/home_screen.dart';
import 'services/feature_flag_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Register the FoodLogAdapter
  Hive.registerAdapter(FoodLogAdapter());

  // Open the Hive box
  await Hive.openBox<FoodLog>('food_logs');

  final featureFlagService = FeatureFlagService();
  await featureFlagService.loadFeatureFlags();
  await featureFlagService.loadAWSConfigurations();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: FeatureFlagService().isFeatureEnabled('enableDarkMode') ? true : false,
      title: 'Baby Food Log',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
