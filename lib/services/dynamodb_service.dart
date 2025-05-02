import 'package:aws_client/dynamo_document.dart';
import 'feature_flag_service.dart';

class DynamoDBService {
  final DynamoDB dynamoDB;

  DynamoDBService()
      : dynamoDB = DynamoDB(
          region: FeatureFlagService().getConfigValue('AWSConfig', 'Region'), // Replace with your AWS region
          credentials: AwsClientCredentials(
            accessKey: FeatureFlagService().getConfigValue('AWSConfig', 'AWSAccessKey'),
            secretKey: FeatureFlagService().getConfigValue('AWSConfig', 'AWSSecretKey'),
          ),
        );

  Future<void> addFoodLog(Map<String, dynamic> foodLog) async {
    await dynamoDB.putItem(
      tableName: 'FoodLogs',
      item: foodLog.map((key, value) => MapEntry(key, AttributeValue(s: value.toString()))),
    );
  }
}