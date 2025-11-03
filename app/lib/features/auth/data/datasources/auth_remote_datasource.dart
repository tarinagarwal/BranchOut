import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  Future<UserModel> getMe() async {
    try {
      final response = await _apiClient.get('/auth/me');
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
      await _apiClient.clearToken();
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  Future<void> saveToken(String token) async {
    await _apiClient.setToken(token);
  }

  Future<String?> getToken() async {
    return await _apiClient.getToken();
  }
}
