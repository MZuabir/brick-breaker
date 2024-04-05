
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:brick_breaker/modals/game_session.dart';


class ModelProvider implements amplify_core.ModelProviderInterface {
  @override
  String version = "a6f518adb8279601623a2aea86ab3b5f";
  @override
  List<amplify_core.ModelSchema> modelSchemas = [GameSession.schema];
  @override
  List<amplify_core.ModelSchema> customTypeSchemas = [];
  static final ModelProvider _instance = ModelProvider();

  static ModelProvider get instance => _instance;
  
  amplify_core.ModelType getModelTypeByModelName(String modelName) {
    switch(modelName) {
      case "GameSession":
        return GameSession.classType;
      default:
        throw Exception("Failed to find model in model provider for model name: " + modelName);
    }
  }
}


class ModelFieldValue<T> {
  const ModelFieldValue.value(this.value);

  final T value;
}