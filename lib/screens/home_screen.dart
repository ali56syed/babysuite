import 'package:alaras_app/services/dynamodb_service.dart';
import 'package:flutter/material.dart';
import '../helpers/yaml_helper.dart';
import '../models/food_log.dart';
import 'add_food_log_screen.dart';
import 'food_log_detail_screen.dart';
import '../components/navbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DynamoDBService dynamoDBService = DynamoDBService();
  late Future<void> _dynamoDbServiceInitialization;
  List<FoodLog> logs = [];
  late bool isNavbarEnabled = YamlHelper().isFeatureEnabled('navbar'); 

    @override
  void initState() {
    super.initState();
    _dynamoDbServiceInitialization = _initializeDynamoDBService(); // Initialize the Hive box asynchronously
  }

  Future<void> _initializeDynamoDBService() async {
    final fetchedLogs = await dynamoDBService.fetchFoodLogs(); // Fetch logs as List<Map<String, dynamic>>
    setState(() {
      logs = fetchedLogs.map((log) => FoodLog.fromMap(log)).toList(); // Convert to List<FoodLog>
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Baby Food Log'),
            Text(
              'Alara has had ${logs.length} different food items!',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: FoodLogSearchDelegate(logs),
              );
            },
          ),
        ],
      ),
      drawer: isNavbarEnabled ? Navbar() : null,
      body: logs.isEmpty
          ? Center(child: Text('No food logs yet.'))
          : RefreshIndicator(
              onRefresh: _initializeDynamoDBService, // Pull-to-refresh functionality
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return ListTile(
                    title: Text(log.foodName),
                    subtitle: Text('Date: ${log.date.toLocal().toString().split(' ')[0]}'),
                    leading: Icon(Icons.fastfood_outlined),
                    trailing: log.hadReaction
                        ? Icon(
                            Icons.info,
                            color: Colors.red,
                          )
                        : null,
                    onTap: () async {
                      // Navigate to FoodLogDetailScreen
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FoodLogDetailScreen(foodLog: log),
                        ),
                      );

                      // Refresh logs if a log was deleted
                      if (result == true) {
                        await _initializeDynamoDBService();
                      }
                    },
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // Navigate to AddFoodLogScreen
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddFoodLogScreen(logs),
            ),
          );

          // Refresh logs after adding a new entry
          if (result == true) {
            await _initializeDynamoDBService(); // Fetch the latest logs
          }
        },
      ),
    );
  }
}

class FoodLogSearchDelegate extends SearchDelegate {
  final List<FoodLog> logs;

  FoodLogSearchDelegate(this.logs);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = logs.where((log) => log.foodName.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final log = results[index];
        return ListTile(
          title: Text(log.foodName),
          subtitle: Text('Date: ${log.date.toLocal().toString().split(' ')[0]}'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FoodLogDetailScreen(foodLog: log),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = logs.where((log) => log.foodName.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final log = suggestions[index];
        return ListTile(
          title: Text(log.foodName),
          subtitle: Text('Date: ${log.date.toLocal().toString().split(' ')[0]}'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FoodLogDetailScreen(foodLog: log),
              ),
            );
          },
        );
      },
    );
  }
}