class ProfileCardModel {
  final String id;
  final String name;
  final String? profilePhoto;
  final String experience;
  final String? bio;
  final List<String> techStack;
  final List<String> lookingFor;
  final String? location;
  final int compatibilityScore;
  final List<ProjectPreview> projects;

  ProfileCardModel({
    required this.id,
    required this.name,
    this.profilePhoto,
    required this.experience,
    this.bio,
    required this.techStack,
    required this.lookingFor,
    this.location,
    this.compatibilityScore = 0,
    this.projects = const [],
  });

  factory ProfileCardModel.fromJson(Map<String, dynamic> json) {
    return ProfileCardModel(
      id: json['id'],
      name: json['name'],
      profilePhoto: json['profilePhoto'],
      experience: json['experience'],
      bio: json['bio'],
      techStack: List<String>.from(json['techStack'] ?? []),
      lookingFor: List<String>.from(json['lookingFor'] ?? []),
      location: json['location'],
      compatibilityScore: json['compatibilityScore'] ?? 0,
      projects: (json['projects'] as List?)
              ?.map((p) => ProjectPreview.fromJson(p))
              .toList() ??
          [],
    );
  }
}

class ProjectPreview {
  final String id;
  final String title;
  final String description;
  final String? githubLink;
  final String? screenshot;

  ProjectPreview({
    required this.id,
    required this.title,
    required this.description,
    this.githubLink,
    this.screenshot,
  });

  factory ProjectPreview.fromJson(Map<String, dynamic> json) {
    return ProjectPreview(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      githubLink: json['githubLink'],
      screenshot: json['screenshot'],
    );
  }
}
