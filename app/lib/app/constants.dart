class AppConstants {
  // API
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );
  static const String socketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'http://localhost:3000',
  );

  // Swipe limits
  static const int freeSwipeLimit = 50;
  static const int freeSuperLikeLimit = 3;

  // Bio
  static const int maxBioLength = 250;

  // Experience levels
  static const List<String> experienceLevels = [
    'Junior',
    'Mid',
    'Senior',
    'Lead',
  ];

  // Looking for options
  static const List<String> lookingForOptions = [
    'Collaborator',
    'Co-founder',
    'Mentor',
    'Mentee',
    'Job',
    'Networking',
  ];

  // Availability status
  static const List<String> availabilityOptions = [
    'Active',
    'Open to offers',
    'Just browsing',
  ];
}
