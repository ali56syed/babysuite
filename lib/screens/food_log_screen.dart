import 'package:alaras_app/services/dynamodb_service.dart';
import 'package:flutter/material.dart';
import '../helpers/yaml_helper.dart';
import '../models/food_log.dart';
import 'add_food_log_screen.dart';
import 'food_log_detail_screen.dart';
import '../components/navbar.dart';

class FoodLogScreen extends StatefulWidget {
  @override
  _FoodLogScreenState createState() => _FoodLogScreenState();
}

class _FoodLogScreenState extends State<FoodLogScreen> {
  DynamoDBService dynamoDBService = DynamoDBService();
  late Future<void> _dynamoDbServiceInitialization;
  List<FoodLog> logs = [];
  late bool isNavbarEnabled = YamlHelper().isFeatureEnabled('navbar');
  
  // Filter state variables
  bool? _reactionFilter; // null = all, true = with reactions, false = without reactions
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _dynamoDbServiceInitialization = _initializeDynamoDBService();
  }

  Future<void> _initializeDynamoDBService() async {
    final fetchedLogs = await dynamoDBService.fetchFoodLogs();
    setState(() {
      logs = fetchedLogs.map((log) => FoodLog.fromMap(log)).toList();
    });
  }

  // Get filtered logs based on current filter settings
  List<FoodLog> get _filteredLogs {
    return logs.where((log) {
      // Apply reaction filter
      if (_reactionFilter != null && log.hadReaction != _reactionFilter) {
        return false;
      }

      // Apply date range filter
      if (_startDate != null && log.date.isBefore(_startDate!)) {
        return false;
      }
      if (_endDate != null && log.date.isAfter(_endDate!)) {
        return false;
      }

      return true;
    }).toList();
  }

  // Helper method to check if any filters are active
  bool get _hasActiveFilters {
    return _reactionFilter != null || _startDate != null || _endDate != null;
  }

  // Helper method to get filter description
  String get _filterDescription {
    List<String> activeFilters = [];
    
    if (_reactionFilter != null) {
      activeFilters.add(_reactionFilter! ? 'With Reactions' : 'Without Reactions');
    }
    
    if (_startDate != null || _endDate != null) {
      String dateRange = '';
      if (_startDate != null) {
        dateRange += 'From: ${_startDate!.toLocal().toString().split(' ')[0]}';
      }
      if (_endDate != null) {
        if (dateRange.isNotEmpty) dateRange += ' ';
        dateRange += 'To: ${_endDate!.toLocal().toString().split(' ')[0]}';
      }
      activeFilters.add(dateRange);
    }
    
    return activeFilters.join(' | ');
  }

  void _showFilterDialog() {
    // Temporary variables to store date selections before applying
    DateTime? tempStartDate = _startDate;
    DateTime? tempEndDate = _endDate;
    bool? tempReactionFilter = _reactionFilter;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Center(
            child: Text('Filter Food Logs'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Reaction filter
              DropdownButton<bool?>(
                value: tempReactionFilter,
                hint: Text('Filter by Reaction'),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text('All'),
                  ),
                  DropdownMenuItem(
                    value: true,
                    child: Text('With Reactions'),
                  ),
                  DropdownMenuItem(
                    value: false,
                    child: Text('Without Reactions'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    tempReactionFilter = value;
                  });
                },
              ),
              SizedBox(height: 16),
              // Date range filter
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: tempStartDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            tempStartDate = date;
                          });
                        }
                      },
                      child: Text(tempStartDate == null
                          ? 'Start Date'
                          : 'From: ${tempStartDate!.toLocal().toString().split(' ')[0]}'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: tempEndDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            tempEndDate = date;
                          });
                        }
                      },
                      child: Text(tempEndDate == null
                          ? 'End Date'
                          : 'To: ${tempEndDate!.toLocal().toString().split(' ')[0]}'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Apply and Cancel buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      this.setState(() {
                        _reactionFilter = tempReactionFilter;
                        _startDate = tempStartDate;
                        _endDate = tempEndDate;
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Apply'),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Baby Food Log'),
            if (_hasActiveFilters)
              Text(
                _filterDescription,
                style: TextStyle(fontSize: 12, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            Text(
              'Alara has had ${_filteredLogs.length} different food items!',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          if (_hasActiveFilters)
            IconButton(
              icon: Icon(Icons.clear_all),
              onPressed: () {
                setState(() {
                  _reactionFilter = null;
                  _startDate = null;
                  _endDate = null;
                });
              },
              tooltip: 'Clear Filters',
            ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: FoodLogSearchDelegate(logs),
              );
            },
            tooltip: 'Search',
          ),
        ],
      ),
      drawer: isNavbarEnabled ? Navbar() : null,
      body: _filteredLogs.isEmpty
          ? Center(child: Text('No food logs found.'))
          : RefreshIndicator(
              onRefresh: _initializeDynamoDBService,
              child: ListView.builder(
                itemCount: _filteredLogs.length,
                itemBuilder: (context, index) {
                  final log = _filteredLogs[index];
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
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FoodLogDetailScreen(foodLog: log),
                        ),
                      );

                      if (result == true) {
                        await _initializeDynamoDBService();
                      }
                    },
                  );
                },
              ),
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'filter',
            child: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'add',
            child: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddFoodLogScreen(logs),
                ),
              );

              if (result == true) {
                await _initializeDynamoDBService();
              }
            },
          ),
        ],
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