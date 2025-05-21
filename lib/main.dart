import 'package:flutter/material.dart';
import 'screens/add_food_log_screen.dart';
import 'screens/food_log_screen.dart';
import 'helpers/yaml_helper.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final helper = YamlHelper();
  await helper.loadFeatureFlags();
  await helper.loadAWSConfigurations();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: YamlHelper().isFeatureEnabled('enableDarkMode') ? true : false,
      title: 'Baby Food Log',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/': (context) => FoodLogScreen(),
        '/foodLog': (context) => FoodLogScreen(),
        '/addFoodLog': (context) => AddFoodLogScreen([]),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
