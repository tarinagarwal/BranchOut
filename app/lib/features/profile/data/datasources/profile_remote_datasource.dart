import '../../../../core/network/api_client.dart';
import '../../../auth/domain/models/user_model.dart';

class ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSource(this._apiClient);

  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put('/users/profile', data: data);
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _apiClient.delete('/users/account');
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  Future<UserModel> getProfile(String userId) async {
    try {
      final response = await _apiClient.get('/users/profile/$userId');
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }
}
