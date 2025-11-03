import '../../../../core/network/api_client.dart';
import '../../domain/models/profile_card_model.dart';

class DiscoverRemoteDataSource {
  final ApiClient _apiClient;

  DiscoverRemoteDataSource(this._apiClient);

  Future<List<ProfileCardModel>> getProfiles({
    String? experience,
    List<String>? techStack,
    List<String>? lookingFor,
    String? location,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (experience != null) queryParams['experience'] = experience;
      if (techStack != null && techStack.isNotEmpty) {
        queryParams['techStack'] = techStack.join(',');
      }
      if (lookingFor != null && lookingFor.isNotEmpty) {
        queryParams['lookingFor'] = lookingFor.join(',');
      }
      if (location != null) queryParams['location'] = location;

      final response = await _apiClient.get('/users/discover', queryParameters: queryParams);
      
      return (response.data as List)
          .map((json) => ProfileCardModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch profiles: $e');
    }
  }

  Future<Map<String, dynamic>> swipe({
    required String swipedUserId,
    required String direction,
  }) async {
    try {
      final response = await _apiClient.post('/swipes', data: {
        'swipedUserId': swipedUserId,
        'direction': direction,
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to record swipe: $e');
    }
  }
}
