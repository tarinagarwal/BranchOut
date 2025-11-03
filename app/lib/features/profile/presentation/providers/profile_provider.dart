import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/profile_remote_datasource.dart';

final profileDataSourceProvider = Provider<ProfileRemoteDataSource>(
  (ref) => ProfileRemoteDataSource(ref.watch(apiClientProvider)),
);

final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<void>>((ref) {
  return ProfileNotifier(
    ref.watch(profileDataSourceProvider),
    ref,
  );
});

class ProfileNotifier extends StateNotifier<AsyncValue<void>> {
  final ProfileRemoteDataSource _dataSource;
  final Ref _ref;

  ProfileNotifier(this._dataSource, this._ref) : super(const AsyncValue.data(null));

  Future<void> updateProfile(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final updatedUser = await _dataSource.updateProfile(data);
      _ref.read(authStateProvider.notifier).updateUser(updatedUser);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    try {
      await _dataSource.deleteAccount();
      await _ref.read(authStateProvider.notifier).logout();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
