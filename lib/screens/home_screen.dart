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
  
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<FoodLog>('food_logs');
    final logs = box.values.toList();

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
                  leading: Icon(
                    Icons.fastfood_outlined,
                  ),
                  trailing: log.hadReaction ? Icon(
                    Icons.info,
                    color: log.hadReaction ? Colors.red : null,
                  ) : null,
                  onTap: () async {
                    // Navigate to FoodLogDetailScreen
                    print('Navigating to details of: ${log.foodName}'); // Debug print
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FoodLogDetailScreen(foodLog: log),
                      ),
                    );
                    // Fetch updated logs after returning
                    setState(() {});
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // Navigate to AddFoodLogScreen (you need to implement this screen)
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddFoodLogScreen(),
            ),
          );

          // Refresh the state to reflect new entries
          setState(() {});
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