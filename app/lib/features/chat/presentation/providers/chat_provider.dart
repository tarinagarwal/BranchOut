import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../domain/models/message_model.dart';

final chatDataSourceProvider = Provider<ChatRemoteDataSource>(
  (ref) => ChatRemoteDataSource(ref.watch(apiClientProvider)),
);

final chatProvider = StateNotifierProvider.family<ChatNotifier, AsyncValue<List<MessageModel>>, String>(
  (ref, matchId) {
    return ChatNotifier(
      matchId: matchId,
      dataSource: ref.watch(chatDataSourceProvider),
    );
  },
);

class ChatNotifier extends StateNotifier<AsyncValue<List<MessageModel>>> {
  final String matchId;
  final ChatRemoteDataSource _dataSource;
  IO.Socket? _socket;

  ChatNotifier({
    required this.matchId,
    required ChatRemoteDataSource dataSource,
  })  : _dataSource = dataSource,
        super(const AsyncValue.loading());

  Future<void> loadMessages() async {
    try {
      final messages = await _dataSource.getMessages(matchId);
      state = AsyncValue.data(messages);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void connectSocket() {
    final socketUrl = dotenv.env['SOCKET_URL'] ?? 'http://localhost:3000';
    
    _socket = IO.io(
      socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket?.connect();

    _socket?.on('connect', (_) {
      _socket?.emit('join-match', matchId);
    });

    _socket?.on('receive-message', (data) {
      final message = MessageModel.fromJson(data);
      state.whenData((messages) {
        state = AsyncValue.data([...messages, message]);
      });
    });

    _socket?.on('user-typing', (data) {
      // TODO: Handle typing indicator
    });

    _socket?.on('user-stopped-typing', (data) {
      // TODO: Handle typing indicator
    });
  }

  void disconnectSocket() {
    _socket?.disconnect();
    _socket?.dispose();
  }

  Future<void> sendMessage({
    required String content,
    required String type,
  }) async {
    try {
      // TODO: Get receiver ID from match data
      final message = await _dataSource.sendMessage(
        matchId: matchId,
        receiverId: 'receiver-id', // Placeholder
        content: content,
        type: type,
      );

      // Emit via socket for real-time delivery
      _socket?.emit('send-message', {
        'matchId': matchId,
        'message': message.toJson(),
      });

      // Add to local state
      state.whenData((messages) {
        state = AsyncValue.data([...messages, message]);
      });
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  void startTyping() {
    _socket?.emit('typing-start', {'matchId': matchId, 'userId': 'current-user-id'});
  }

  void stopTyping() {
    _socket?.emit('typing-stop', {'matchId': matchId, 'userId': 'current-user-id'});
  }
}
