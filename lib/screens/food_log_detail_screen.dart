import 'dart:io';

import 'package:flutter/material.dart';
import '../models/food_log.dart';
import '../services/dynamodb_service.dart';

class FoodLogDetailScreen extends StatelessWidget {
  final FoodLog foodLog;

  const FoodLogDetailScreen({Key? key, required this.foodLog}) : super(key: key);

  Future<void> _deleteFoodLog(BuildContext context) async {
    final dynamoDBService = DynamoDBService();

    // Show confirmation dialog
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Food Log'),
        content: Text('Are you sure you want to delete this food log?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      try {
        // Delete the food log from DynamoDB
        await dynamoDBService.deleteFoodLog(foodLog.id);

        // Navigate back to the previous screen and pass a result
        Navigator.of(context).pop(true); // Pass `true` to indicate deletion

        // Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${foodLog.foodName} deleted.')),
        );
      } catch (e) {
        // Handle errors during deletion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete ${foodLog.foodName}.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Log Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteFoodLog(context),
          ),
        ],
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
            Text('Had Reaction: ${foodLog.hadReaction == true ? "Yes" : "No"}'),
            if (foodLog.hadReaction == true)
              SizedBox(height: 8),
            if (foodLog.hadReaction == true)
              Text('Reaction Notes: ${foodLog.reactionNotes}'),
            if (foodLog.imagePath != null && foodLog.imagePath!.isNotEmpty)
              SizedBox(height: 8),
            if (foodLog.imagePath != null && foodLog.imagePath!.isNotEmpty)
              Image.file(
                File(foodLog.imagePath!),
                height: 200,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}