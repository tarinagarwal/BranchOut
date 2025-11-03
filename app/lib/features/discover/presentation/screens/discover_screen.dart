import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../providers/discover_provider.dart';
import '../widgets/profile_card.dart';
import '../../../../app/theme.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final CardSwiperController _controller = CardSwiperController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesState = ref.watch(profilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: profilesState.when(
        data: (profiles) {
          if (profiles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No more profiles to show'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(profilesProvider.notifier).loadProfiles();
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: CardSwiper(
                  controller: _controller,
                  cardsCount: profiles.length,
                  onSwipe: (previousIndex, currentIndex, direction) {
                    final profile = profiles[previousIndex];
                    String swipeDirection;
                    
                    switch (direction) {
                      case CardSwiperDirection.right:
                        swipeDirection = 'right';
                        break;
                      case CardSwiperDirection.left:
                        swipeDirection = 'left';
                        break;
                      case CardSwiperDirection.top:
                        swipeDirection = 'up';
                        break;
                      default:
                        return true;
                    }

                    _handleSwipe(profile.id, swipeDirection);
                    return true;
                  },
                  cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                    return ProfileCard(profile: profiles[index]);
                  },
                ),
              ),
              _buildActionButtons(),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(profilesProvider.notifier).loadProfiles();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Pass Button
          FloatingActionButton(
            heroTag: 'pass',
            onPressed: () => _controller.swipe(CardSwiperDirection.left),
            backgroundColor: AppTheme.passColor,
            child: const Icon(Icons.close, size: 32),
          ),
          // Super Like Button
          FloatingActionButton(
            heroTag: 'superlike',
            onPressed: () => _controller.swipe(CardSwiperDirection.top),
            backgroundColor: AppTheme.superLikeColor,
            child: const Icon(Icons.star, size: 32),
          ),
          // Like Button
          FloatingActionButton(
            heroTag: 'like',
            onPressed: () => _controller.swipe(CardSwiperDirection.right),
            backgroundColor: AppTheme.matchColor,
            child: const Icon(Icons.favorite, size: 32),
          ),
        ],
      ),
    );
  }

  void _handleSwipe(String userId, String direction) async {
    try {
      final result = await ref.read(profilesProvider.notifier).swipe(userId, direction);
      
      if (result['match'] != null && mounted) {
        _showMatchDialog(result['match']);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showMatchDialog(Map<String, dynamic> match) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 It\'s a Match!'),
        content: const Text('You both liked each other!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Swiping'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to chat
            },
            child: const Text('Send Message'),
          ),
        ],
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filters',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Filter options coming soon...'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
