import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/matches_provider.dart';
import '../../../chat/presentation/screens/chat_screen.dart';

class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesState = ref.watch(matchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
      ),
      body: matchesState.when(
        data: (matches) {
          if (matches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No matches yet'),
                  const SizedBox(height: 8),
                  const Text(
                    'Start swiping to find your matches!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: match.otherUser.profilePhoto != null
                        ? CachedNetworkImageProvider(match.otherUser.profilePhoto!)
                        : null,
                    child: match.otherUser.profilePhoto == null
                        ? const Icon(Icons.person, size: 30)
                        : null,
                  ),
                  title: Text(
                    match.otherUser.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(match.otherUser.experience),
                      const SizedBox(height: 4),
                      if (match.otherUser.techStack.isNotEmpty)
                        Text(
                          match.otherUser.techStack.take(3).join(', '),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                  trailing: const Icon(Icons.chat_bubble_outline),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          matchId: match.id,
                          otherUserName: match.otherUser.name,
                          otherUserPhoto: match.otherUser.profilePhoto,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
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
                  ref.read(matchesProvider.notifier).loadMatches();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

