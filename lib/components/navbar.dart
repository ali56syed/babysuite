import 'package:flutter/material.dart';
import '../helpers/yaml_helper.dart';

class Navbar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final isNavbarEnabled = YamlHelper().isFeatureEnabled('navbar');

    if (!isNavbarEnabled) {
      // Return an empty widget if the feature is disabled
      return SizedBox.shrink();
    }
    

    // Return the actual Drawer widget if the feature is enabled
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6, // Set the width to 60% of the screen
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'BabySuite',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Navigation Menu',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Food Log'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/addFoodLog'); // Navigate to AddFoodLogScreen
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/settings'); // Navigate to SettingsScreen
              },
            ),
          ],
        ),
      ),
    );
  }
}