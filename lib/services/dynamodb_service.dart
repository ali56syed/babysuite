import 'dart:convert';
import 'package:aws_client/dynamo_document.dart';

class DynamoDBService {
  final DynamoDB dynamoDB;

  DynamoDBService()
      : dynamoDB = DynamoDB(
          region: 'us-east-2', // Replace with your AWS region
          credentials: AwsClientCredentials(
            accessKey: 'AKIAWRMQJCMEB4LEZM7A', // Replace with your Access Key
            secretKey: '/QUY4fUYVOloyl4ATwEjPfjCTbUm5HMESAYV4kkK', // Replace with your Secret Key
          ),
        );

  Future<void> addFoodLog(Map<String, dynamic> foodLog) async {
    await dynamoDB.putItem(
      tableName: 'FoodLogs',
      item: foodLog.map((key, value) => MapEntry(key, AttributeValue(s: value.toString()))),
    );
  }
}