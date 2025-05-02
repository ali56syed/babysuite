import 'package:aws_client/dynamo_document.dart';
import '../helpers/yaml_helper.dart';

class DynamoDBService {
  final DynamoDB dynamoDB;

  DynamoDBService()
      : dynamoDB = DynamoDB(
          region: YamlHelper().getConfigValue('AWSConfig', 'Region'), // Replace with your AWS region
          credentials: AwsClientCredentials(
            accessKey: YamlHelper().getConfigValue('AWSConfig', 'AWSAccessKey'),
            secretKey: YamlHelper().getConfigValue('AWSConfig', 'AWSSecretKey'),
          ),
        );

  Future<void> addFoodLog(Map<String, dynamic> foodLog) async {
    await dynamoDB.putItem(
      tableName: 'FoodLogs',
      item: foodLog.map((key, value) => MapEntry(key, AttributeValue(s: value.toString()))),
    );
  }
}