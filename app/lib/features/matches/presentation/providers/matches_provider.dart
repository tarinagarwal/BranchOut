import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/matches_remote_datasource.dart';
import '../../domain/models/match_model.dart';

final matchesDataSourceProvider = Provider<MatchesRemoteDataSource>(
  (ref) => MatchesRemoteDataSource(ref.watch(apiClientProvider)),
);

final matchesProvider = StateNotifierProvider<MatchesNotifier, AsyncValue<List<MatchModel>>>((ref) {
  return MatchesNotifier(ref.watch(matchesDataSourceProvider));
});

class MatchesNotifier extends StateNotifier<AsyncValue<List<MatchModel>>> {
  final MatchesRemoteDataSource _dataSource;

  MatchesNotifier(this._dataSource) : super(const AsyncValue.loading()) {
    loadMatches();
  }

  Future<void> loadMatches() async {
    state = const AsyncValue.loading();
    try {
      final matches = await _dataSource.getMatches();
      state = AsyncValue.data(matches);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void addMatch(MatchModel match) {
    state.whenData((matches) {
      state = AsyncValue.data([match, ...matches]);
    });
  }
}
