import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/discover_remote_datasource.dart';
import '../../domain/models/profile_card_model.dart';

final discoverDataSourceProvider = Provider<DiscoverRemoteDataSource>(
  (ref) => DiscoverRemoteDataSource(ref.watch(apiClientProvider)),
);

final profilesProvider = StateNotifierProvider<ProfilesNotifier, AsyncValue<List<ProfileCardModel>>>((ref) {
  return ProfilesNotifier(ref.watch(discoverDataSourceProvider));
});

class ProfilesNotifier extends StateNotifier<AsyncValue<List<ProfileCardModel>>> {
  final DiscoverRemoteDataSource _dataSource;

  ProfilesNotifier(this._dataSource) : super(const AsyncValue.loading()) {
    loadProfiles();
  }

  Future<void> loadProfiles({
    String? experience,
    List<String>? techStack,
    List<String>? lookingFor,
    String? location,
  }) async {
    state = const AsyncValue.loading();
    try {
      final profiles = await _dataSource.getProfiles(
        experience: experience,
        techStack: techStack,
        lookingFor: lookingFor,
        location: location,
      );
      state = AsyncValue.data(profiles);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<Map<String, dynamic>> swipe(String userId, String direction) async {
    try {
      final result = await _dataSource.swipe(
        swipedUserId: userId,
        direction: direction,
      );
      
      // Remove swiped profile from list
      state.whenData((profiles) {
        state = AsyncValue.data(
          profiles.where((p) => p.id != userId).toList(),
        );
      });
      
      return result;
    } catch (e) {
      rethrow;
    }
  }

  void removeProfile(String userId) {
    state.whenData((profiles) {
      state = AsyncValue.data(
        profiles.where((p) => p.id != userId).toList(),
      );
    });
  }
}
