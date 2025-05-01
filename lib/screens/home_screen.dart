import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/food_log.dart';
import 'add_food_log_screen.dart';
import 'food_log_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _hiveInitialization;
  late Box<FoodLog> box;
  List<FoodLog> logs = [];

  @override
  void initState() {
    super.initState();
    _hiveInitialization = _initializeHiveBox(); // Initialize the Hive box asynchronously
  }

  Future<void> _initializeHiveBox() async {
    box = await Hive.openBox<FoodLog>('food_logs'); // Open the Hive box
    setState(() {
      logs = box.values.toList(); // Fetch initial logs after the box is initialized
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _hiveInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while the Hive box is being initialized
          return Scaffold(
            appBar: AppBar(title: Text('Baby Food Log')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          // Handle errors during Hive initialization
          return Scaffold(
            appBar: AppBar(title: Text('Baby Food Log')),
            body: Center(child: Text('Failed to load data. Please try again.')),
          );
        }

        // Render the main UI once the Hive box is ready
        return Scaffold(
          appBar: AppBar(
            title: Text('Baby Food Log'),
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
          body: logs.isEmpty
              ? Center(child: Text('No food logs yet.'))
              : ListView.builder(
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
                          setState(() {
                            logs = box.values.toList(); // Fetch updated logs from Hive
                          });
                        }
                      },
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              // Navigate to AddFoodLogScreen
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddFoodLogScreen(),
                ),
              );

              // Refresh logs after adding a new entry
              setState(() {
                logs = box.values.toList();
              });
            },
          ),
        );
      },
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