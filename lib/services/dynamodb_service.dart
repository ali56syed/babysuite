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

  Future<List<Map<String, dynamic>>> fetchFoodLogs() async {
    final response = await dynamoDB.scan(tableName: 'FoodLogs');
    final items = response.items;

      if (items == null) {
        return [];
      }

    final logs = items.map((item) {
      return item.map((key, value) => MapEntry(key, value.s ?? '')) // Convert AttributeValue to String
        ..['date'] = DateTime.parse(item['date']?.s ?? '').toIso8601String() // Ensure date is in ISO 8601 format
        ..remove('imagePath'); // Remove imagePath if not needed
    }).toList();

    logs.sort((a, b) => (a['id'] ?? '').compareTo(b['id'] ?? ''));

    return logs;
  }

  Future<void> deleteFoodLog(String id) async {
    await dynamoDB.deleteItem(
      tableName: 'FoodLogs',
      key: {
        'id': AttributeValue(s: id),
      },
    );
  }

  Future<void> addFoodLog(Map<String, dynamic> foodLog) async {
    
    await dynamoDB.putItem(
      tableName: 'FoodLogs',
      item: foodLog.map((key, value) => MapEntry(key, AttributeValue(s: value))),
    );
  }
}