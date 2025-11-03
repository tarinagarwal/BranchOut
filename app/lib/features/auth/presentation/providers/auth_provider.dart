import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../domain/models/user_model.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final authDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(ref.watch(apiClientProvider)),
);

final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref.watch(authDataSourceProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRemoteDataSource _dataSource;

  AuthNotifier(this._dataSource) : super(const AsyncValue.loading()) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    try {
      final token = await _dataSource.getToken();
      if (token != null) {
        final user = await _dataSource.getMe();
        state = AsyncValue.data(user);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e) {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login(String token) async {
    try {
      await _dataSource.saveToken(token);
      final user = await _dataSource.getMe();
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logout() async {
    try {
      await _dataSource.logout();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void updateUser(UserModel user) {
    state = AsyncValue.data(user);
  }
}
