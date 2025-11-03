import '../../../../core/network/api_client.dart';
import '../../domain/models/message_model.dart';

class ChatRemoteDataSource {
  final ApiClient _apiClient;

  ChatRemoteDataSource(this._apiClient);

  Future<List<MessageModel>> getMessages(String matchId) async {
    try {
      final response = await _apiClient.get('/messages/$matchId');
      return (response.data as List)
          .map((json) => MessageModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch messages: $e');
    }
  }

  Future<MessageModel> sendMessage({
    required String matchId,
    required String receiverId,
    required String content,
    required String type,
  }) async {
    try {
      final response = await _apiClient.post('/messages', data: {
        'matchId': matchId,
        'receiverId': receiverId,
        'content': content,
        'type': type,
      });
      return MessageModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<void> markAsRead(String messageId) async {
    try {
      await _apiClient.put('/messages/$messageId/read');
    } catch (e) {
      throw Exception('Failed to mark message as read: $e');
    }
  }
}
