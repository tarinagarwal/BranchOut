class MessageModel {
  final String id;
  final String matchId;
  final String senderId;
  final String receiverId;
  final String content;
  final String type; // text, code, image, link
  final bool isRead;
  final DateTime createdAt;
  final SenderInfo? sender;

  MessageModel({
    required this.id,
    required this.matchId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.sender,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      matchId: json['matchId'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
      type: json['type'] ?? 'text',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      sender: json['sender'] != null ? SenderInfo.fromJson(json['sender']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matchId': matchId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class SenderInfo {
  final String id;
  final String name;
  final String? profilePhoto;

  SenderInfo({
    required this.id,
    required this.name,
    this.profilePhoto,
  });

  factory SenderInfo.fromJson(Map<String, dynamic> json) {
    return SenderInfo(
      id: json['id'],
      name: json['name'],
      profilePhoto: json['profilePhoto'],
    );
  }
}
