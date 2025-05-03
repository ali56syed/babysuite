import 'package:flutter/material.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
