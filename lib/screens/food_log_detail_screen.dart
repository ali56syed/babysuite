import 'package:flutter/material.dart';
import '../models/food_log.dart';

class FoodLogDetailScreen extends StatelessWidget {
  final FoodLog foodLog;

  const FoodLogDetailScreen({Key? key, required this.foodLog}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Log Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Food Name: ${foodLog.foodName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Date: ${foodLog.date.toLocal().toString().split(' ')[0]}'),
            SizedBox(height: 8),
            Text('Quantity: ${foodLog.quantity}'),
            SizedBox(height: 8),
            Text('Had Reaction: ${foodLog.hadReaction ? "Yes" : "No"}'),
            if (foodLog.hadReaction)
              SizedBox(height: 8),
            if (foodLog.hadReaction)
              Text('Reaction Notes: ${foodLog.reactionNotes}'),
          ],
        ),
      ),
    );
  }
}