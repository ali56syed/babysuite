import 'dart:io';
import 'package:yaml/yaml.dart';

class FeatureFlagService {
  static final FeatureFlagService _instance = FeatureFlagService._internal();
  late Map<String, dynamic> _flags;

  FeatureFlagService._internal();

  factory FeatureFlagService() {
    return _instance;
  }

  Future<void> loadFeatureFlags() async {
    final file = File('/Users/syed.ali/Repos/babysuite/feature_flags.yaml');
    final yamlString = await file.readAsString();
    final yamlMap = loadYaml(yamlString) as YamlMap;

    _flags = Map<String, dynamic>.from(yamlMap);
  }

  dynamic getFeatureValue(String featureName, [String? key]) {
    if (_flags.isEmpty) {
      throw Exception('Feature flags not loaded. Call loadFeatureFlags() first.');
    }
    if (!_flags.containsKey(featureName)) {
      throw Exception('Feature flag "$featureName" does not exist.');
    }

    final feature = _flags[featureName];
    if (key != null && feature is Map) {
      return feature[key];
    }
    return feature;
  }

  bool isFeatureEnabled(String featureName) {
    if (_flags.isEmpty) {
      throw Exception('Feature flags not loaded. Call loadFeatureFlags() first.');
    }
    if (!_flags.containsKey(featureName)) {
      throw Exception('Feature flag "$featureName" does not exist.');
    }

    final selectedFeature = _flags[featureName];

    return selectedFeature['enabled'] ? true : false;
  }
}