import '../../../../core/network/api_client.dart';
import '../../domain/models/match_model.dart';

class MatchesRemoteDataSource {
  final ApiClient _apiClient;

  MatchesRemoteDataSource(this._apiClient);

  Future<List<MatchModel>> getMatches() async {
    try {
      final response = await _apiClient.get('/swipes/matches');
      
      // TODO: Get current user ID from auth
      const currentUserId = 'current-user-id'; // Placeholder
      
      return (response.data as List)
          .map((json) => MatchModel.fromJson(json, currentUserId))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch matches: $e');
    }
  }
}
