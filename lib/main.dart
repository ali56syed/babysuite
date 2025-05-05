import 'package:flutter/material.dart';
import 'screens/add_food_log_screen.dart';
import 'screens/home_screen.dart';
import 'helpers/yaml_helper.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        // Add other routes here as needed
        '/addFoodLog': (context) => AddFoodLogScreen([]),
        // '/settings': (context) => SettingsScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: HomeScreen(),
    );
  }
}
