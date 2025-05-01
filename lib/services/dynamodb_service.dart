import 'dart:convert';
import 'package:aws_client/dynamo_document.dart';
import 'feature_flag_service.dart';


class DynamoDBService {
  final DynamoDB dynamoDB;

  DynamoDBService()
      : dynamoDB = DynamoDB(
          region: FeatureFlagService().getFeatureValue('mongoDbIntegration','region'), // Replace with your AWS region
          credentials: AwsClientCredentials(
            accessKey: FeatureFlagService().getFeatureValue('mongoDbIntegration','AWSAccessKey'), 
            secretKey: FeatureFlagService().getFeatureValue('mongoDbIntegration','AWSAccessKey'), 
          ),
        );

  Future<void> addFoodLog(Map<String, dynamic> foodLog) async {
    await dynamoDB.putItem(
      tableName: 'FoodLogs',
      item: foodLog.map((key, value) => MapEntry(key, AttributeValue(s: value.toString()))),
    );
  }
}