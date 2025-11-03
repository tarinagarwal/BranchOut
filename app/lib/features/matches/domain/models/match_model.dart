class MatchModel {
  final String id;
  final MatchUser otherUser;
  final DateTime matchedAt;
  final bool isActive;

  MatchModel({
    required this.id,
    required this.otherUser,
    required this.matchedAt,
    required this.isActive,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json, String currentUserId) {
    // Determine which user is the "other" user
    final user1 = json['user1'];
    final user2 = json['user2'];
    final otherUserJson = user1['id'] == currentUserId ? user2 : user1;

    return MatchModel(
      id: json['id'],
      otherUser: MatchUser.fromJson(otherUserJson),
      matchedAt: DateTime.parse(json['matchedAt']),
      isActive: json['isActive'] ?? true,
    );
  }
}

class MatchUser {
  final String id;
  final String name;
  final String? profilePhoto;
  final String? bio;
  final List<String> techStack;
  final String experience;

  MatchUser({
    required this.id,
    required this.name,
    this.profilePhoto,
    this.bio,
    required this.techStack,
    required this.experience,
  });

  factory MatchUser.fromJson(Map<String, dynamic> json) {
    return MatchUser(
      id: json['id'],
      name: json['name'],
      profilePhoto: json['profilePhoto'],
      bio: json['bio'],
      techStack: List<String>.from(json['techStack'] ?? []),
      experience: json['experience'] ?? 'Mid',
    );
  }
}
