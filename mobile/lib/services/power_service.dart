import '../models/power_category.dart';
import 'api_client.dart';

class PowerService {
  final ApiClient _client;

  PowerService(this._client);

  Future<List<PowerCategory>> getCategories() async {
    final json = await _client.get('/power/categories');
    final data = json['data'] as List;
    return data.map((c) => PowerCategory.fromJson(c as Map<String, dynamic>)).toList();
  }

  Future<void> saveSelections(List<int> categoryIds) async {
    await _client.post('/power/selections', body: {
      'categoryIds': categoryIds,
    });
  }

  Future<List<UserPowerSelection>> getSelections() async {
    final json = await _client.get('/power/selections');
    final data = json['data'] as List;
    return data.map((s) => UserPowerSelection.fromJson(s as Map<String, dynamic>)).toList();
  }
}

