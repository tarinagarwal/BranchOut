class UserModel {
  final String id;
  final String email;
  final String name;
  final String? bio;
  final String? location;
  final String? timezone;
  final String? profilePhoto;
  final String experience;
  final String availability;
  final List<String> techStack;
  final List<String> lookingFor;
  final String? githubUsername;
  final Map<String, dynamic>? githubStats;
  final bool isPremium;
  final DateTime? premiumExpiresAt;
  final int superLikesLeft;
  final int swipesLeft;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.bio,
    this.location,
    this.timezone,
    this.profilePhoto,
    required this.experience,
    required this.availability,
    required this.techStack,
    required this.lookingFor,
    this.githubUsername,
    this.githubStats,
    required this.isPremium,
    this.premiumExpiresAt,
    required this.superLikesLeft,
    required this.swipesLeft,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      bio: json['bio'],
      location: json['location'],
      timezone: json['timezone'],
      profilePhoto: json['profilePhoto'],
      experience: json['experience'],
      availability: json['availability'],
      techStack: List<String>.from(json['techStack'] ?? []),
      lookingFor: List<String>.from(json['lookingFor'] ?? []),
      githubUsername: json['githubUsername'],
      githubStats: json['githubStats'],
      isPremium: json['isPremium'] ?? false,
      premiumExpiresAt: json['premiumExpiresAt'] != null
          ? DateTime.parse(json['premiumExpiresAt'])
          : null,
      superLikesLeft: json['superLikesLeft'] ?? 3,
      swipesLeft: json['swipesLeft'] ?? 50,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'bio': bio,
      'location': location,
      'timezone': timezone,
      'profilePhoto': profilePhoto,
      'experience': experience,
      'availability': availability,
      'techStack': techStack,
      'lookingFor': lookingFor,
      'githubUsername': githubUsername,
      'githubStats': githubStats,
      'isPremium': isPremium,
      'premiumExpiresAt': premiumExpiresAt?.toIso8601String(),
      'superLikesLeft': superLikesLeft,
      'swipesLeft': swipesLeft,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
