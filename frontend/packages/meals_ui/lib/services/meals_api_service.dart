import 'package:shared_services/shared_services.dart';

class MealsApiService {
  final BaseApiClient _client;

  MealsApiService({BaseApiClient? client})
      : _client = client ?? BaseApiClient(config: AppConfigs.mealPlanner());

  Future<Map<String, dynamic>> getWeeklyMealPlan(String userId) async {
    return await _client.get<Map<String, dynamic>>(
      '/meals/weekly-plan/$userId',
      fromJson: (json) => json,
    );
  }

  Future<Map<String, dynamic>> getTodayMeals(String userId, {String? date}) async {
    return await _client.get<Map<String, dynamic>>(
      '/meals/today/$userId',
      queryParameters: date != null ? {'date': date} : null,
      fromJson: (json) => json,
    );
  }

  void dispose() {
    _client.dispose();
  }
}
